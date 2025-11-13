using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using pruebatecnica.Models;
using System.Data;
using System.Security.Claims;
[AllowAnonymous]
public class AuthController : Controller
{
    private readonly ConexionBD db;

    public AuthController(ConexionBD conexion)
    {
        db = conexion;
    }

    public async Task<IActionResult> Logout()
    {
        // 🔐 Cierra la sesión de autenticación (cookie)
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

        // 🧹 Limpia toda la sesión
        HttpContext.Session.Clear();

        // 🧽 Borra cookies residuales
        Response.Cookies.Delete(".AspNetCore.Cookies");
        Response.Cookies.Delete(".AspNetCore.Session");

        // 🔁 Redirige al login
        return RedirectToAction("Login", "Auth");
    }

    public IActionResult CambiarPassword()
    {
        if (HttpContext.Session.GetInt32("CambiarPass_IdUsuario") == null)
            return RedirectToAction("Login");

        return View();
    }

    [HttpGet]
    public IActionResult Login() => View();

    [HttpPost]

    public IActionResult CambiarPassword(string nuevaPass, string confirmarPass)
    {
        int? idUsuario = HttpContext.Session.GetInt32("CambiarPass_IdUsuario");

        if (idUsuario == null)
            return RedirectToAction("Login");

        // ✅ Validar coincidencia
        if (nuevaPass != confirmarPass)
        {
            ViewBag.Mensaje = "Las contraseñas no coinciden.";
            return View();
        }

        // ✅ Validar longitud mínima (6)
        if (nuevaPass.Length < 6)
        {
            ViewBag.Mensaje = "La contraseña debe tener mínimo 6 caracteres.";
            return View();
        }

        string query = "EXEC SP_CambiarPassword @idUsuario, @nuevaPass";
        SqlParameter[] parametros =
        {
        new SqlParameter("@idUsuario", idUsuario.Value),
        new SqlParameter("@nuevaPass", nuevaPass)
    };

        DataTable dt = db.EjecutarConsulta(query, parametros);
        string resultado = dt.Rows[0]["Resultado"].ToString();

        if (resultado == "OK")
        {
            HttpContext.Session.Remove("CambiarPass_IdUsuario");

            ViewBag.Mensaje = "✅ Contraseña actualizada correctamente. Inicie sesión.";
            
            HttpContext.SignOutAsync();
            //return RedirectToAction("Login", "Usuarios");
            return View("Login");
        }

        ViewBag.Mensaje = resultado;
        return View();
    }

    public async Task<IActionResult> Login(string usuario, string contrasena)
    {
        string query = "EXEC SP_ValidarLogin @usuario, @contrasena";
        SqlParameter[] parametros =
        {
        new SqlParameter("@usuario", usuario),
        new SqlParameter("@contrasena", contrasena)
    };

        DataTable dt = db.EjecutarConsulta(query, parametros);

        if (dt.Rows.Count == 0)
        {
            ViewBag.Mensaje = "Usuario o contraseña incorrectos.";
            return View();
        }

        DataRow user = dt.Rows[0];
        string resultado = user["Resultado"].ToString();

        // ⚠️ Si el login falló, no hay más columnas que leer
        if (resultado == "Usuario o contraseña incorrectos")
        {
            ViewBag.Mensaje = resultado;
            return View();
        }

        // ✅ ID de usuario (siempre debe venir)
        int idUsuario = Convert.ToInt32(user["idUsuario"]);

        // ✅ Si necesita cambiar contraseña
        if (resultado == "Cambiar contraseña")
        {
            HttpContext.Session.SetInt32("CambiarPass_IdUsuario", idUsuario);
            return RedirectToAction("CambiarPassword");
        }

        // ✅ Solo si fue acceso permitido leemos los demás campos
        if (resultado == "Acceso permitido")
        {
            string estatus = user["status"].ToString();
            TimeSpan horaEntrada = (TimeSpan)user["horarioInicio"];
            TimeSpan horaSalida = (TimeSpan)user["horarioFin"];

            if (estatus == "Baja")
            {
                ViewBag.Mensaje = "Usuario dado de baja.";
                return View();
            }

            // ✅ Verificar horario
            var ahora = DateTime.Now.TimeOfDay;
            if (ahora < horaEntrada || ahora > horaSalida)
            {
                ViewBag.Mensaje = "Fuera de horario permitido.";
                return View();
            }

            // ✅ Obtener permisos del usuario
            string queryPermisos = @"SELECT modulo FROM permisos 
                                 WHERE idUsuario = @idUsuario AND acceso = 1";
            SqlParameter[] paramPermisos = { new SqlParameter("@idUsuario", idUsuario) };
            DataTable permisosDt = db.EjecutarConsulta(queryPermisos, paramPermisos);

            // ✅ Crear Claims
            var claims = new List<Claim>
        {
            new Claim(ClaimTypes.Name, usuario),
            new Claim("idUsuario", idUsuario.ToString())
        };

            foreach (DataRow row in permisosDt.Rows)
                claims.Add(new Claim("permiso", row["modulo"].ToString()));

            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);

            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);
            HttpContext.Session.SetString("Usuario", usuario);
            HttpContext.Session.SetInt32("IdUsuario", idUsuario);
            string queryHist = "EXEC SP_Historico_Insertar @idUsuario, @modulo, @accion, @descripcion";
            SqlParameter[] pHist = {
                new SqlParameter("@idUsuario", idUsuario),
                new SqlParameter("@modulo", "Login"),
                new SqlParameter("@accion", "Inicio sesión"),
                new SqlParameter("@descripcion", $"Usuario {usuario} inició sesión correctamente")
};
            db.EjecutarConsulta(queryHist, pHist);

            return RedirectToAction("Index", "Home");
        }

        // ✅ Si el SP devuelve algo diferente
        ViewBag.Mensaje = resultado;
        return View();
    }
}