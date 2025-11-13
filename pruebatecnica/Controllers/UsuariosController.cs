using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Data;
using Microsoft.Data.SqlClient;
using pruebatecnica.Models;

[Authorize(Policy = "Usuarios")]
public class UsuariosController : Controller
{
    private readonly ConexionBD db;

    public UsuariosController(ConexionBD conexion)
    {
        db = conexion;
    }

    public IActionResult Index()
    {
        DataTable dt = db.EjecutarConsulta("EXEC SP_Usuario_Listar");
        return View(dt);
    }

    public IActionResult Crear() => View();

    [HttpPost]
    public IActionResult Crear(int idUsuario ,string usuario, string contrasena, TimeSpan horarioInicio, TimeSpan horarioFin)
    {
        SqlParameter[] parametros =
        {
            new SqlParameter("@usuario", usuario),
            new SqlParameter("@contrasena", contrasena),
            new SqlParameter("@estatus", "Activo"),
            new SqlParameter("@inicio", horarioInicio),
            new SqlParameter("@fin", horarioFin)
        };

        db.EjecutarConsulta("EXEC SP_Usuario_Insertar @usuario, @contrasena, @estatus, @inicio, @fin", parametros);
        SqlParameter[] pHist = {
    new SqlParameter("@idUsuario", Convert.ToInt32(User.FindFirst("idUsuario")?.Value)),
    new SqlParameter("@modulo", "Usuarios"),
    new SqlParameter("@accion", "Crear"),
    new SqlParameter("@descripcion", $"Creo usuario {usuario}")
};
        db.EjecutarConsulta("EXEC SP_Historico_Insertar @idUsuario, @modulo, @accion, @descripcion", pHist);

        return RedirectToAction("Index");
    }

    public IActionResult Editar(int id)
    {
        SqlParameter[] parametros = { new SqlParameter("@idUsuario", id) };
        DataTable dt = db.EjecutarConsulta("EXEC SP_Usuario_Buscar @idUsuario", parametros);

        if (dt.Rows.Count == 0)
            return RedirectToAction("Index");

        return View(dt.Rows[0]);
    }

    [HttpPost]
    public IActionResult Editar(int idUsuario, string usuario, string password, string estatus, TimeSpan horarioInicio, TimeSpan horarioFin)
    {
        if (password == null) password = ""; // ✅ evita error

        SqlParameter[] parametros =
        {
        new SqlParameter("@idUsuario", idUsuario),
        new SqlParameter("@usuario", usuario),
        new SqlParameter("@password", string.IsNullOrWhiteSpace(password) ? (object)DBNull.Value : password),
        new SqlParameter("@status", estatus),
        new SqlParameter("@horarioInicio", horarioInicio),
        new SqlParameter("@horarioFin", horarioFin)
    };

        db.EjecutarConsulta(
            "EXEC SP_Usuario_Actualizar @idUsuario, @usuario, @password, @status, @horarioInicio, @horarioFin",
            parametros
        );
        SqlParameter[] pHist = {
    new SqlParameter("@idUsuario", Convert.ToInt32(User.FindFirst("idUsuario")?.Value)),
    new SqlParameter("@modulo", "Usuarios"),
    new SqlParameter("@accion", "Actualización"),
    new SqlParameter("@descripcion", $"Editó usuario {usuario}")
};
        db.EjecutarConsulta("EXEC SP_Historico_Insertar @idUsuario, @modulo, @accion, @descripcion", pHist);


        return RedirectToAction("Index");
    }

    public IActionResult Baja(int idUsuario,int id)
    {
        SqlParameter[] parametros = { new SqlParameter("@idUsuario", id) };
        db.EjecutarConsulta("EXEC SP_Usuario_Eliminar @idUsuario", parametros);
        SqlParameter[] pHist = {
    new SqlParameter("@idUsuario", Convert.ToInt32(User.FindFirst("idUsuario")?.Value)),
    new SqlParameter("@modulo", "Usuarios"),
  
    new SqlParameter("@accion", "Baja de usuario"),
new SqlParameter("@descripcion", $"Dio de baja al usuario ID {id}")

};
        db.EjecutarConsulta("EXEC SP_Historico_Insertar @idUsuario, @modulo, @accion, @descripcion", pHist);


        return RedirectToAction("Index");
    }
}
