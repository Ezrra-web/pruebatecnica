using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Data.SqlClient;
using System.Data;
using pruebatecnica.Models;

[Authorize(Policy = "Permisos")]
public class PermisosController : Controller
{
    private readonly ConexionBD db;

    public PermisosController(ConexionBD conexion)
    {
        db = conexion;
    }

    private bool TienePermiso()
    {
        return User.Claims.Any(c => c.Type == "permiso" && c.Value == "Permisos");
    }

    public IActionResult Index()
    {
        if (!TienePermiso())
            return Unauthorized();

        DataTable usuarios = db.EjecutarConsulta("EXEC SP_Usuarios_ListarBasico");
        return View(usuarios);
    }

    public IActionResult Editar(int idUsuario)
    {
        if (!TienePermiso())
            return Unauthorized();

        SqlParameter[] parametros = { new SqlParameter("@idUsuario", idUsuario) };
        DataTable permisos = db.EjecutarConsulta("EXEC SP_Permisos_ListarPorUsuario @idUsuario", parametros);
        ViewBag.idUsuario = idUsuario;

        return View(permisos);
    }

    [HttpPost]
    public IActionResult GuardarPermisos(int idUsuario, string[] modulos)
    {
        // Lista de todos los módulos disponibles
        var modulosDisponibles = new List<string> { "Usuarios", "Registro", "Impresiones", "Permisos" };

        foreach (var modulo in modulosDisponibles)
        {
            bool tieneAcceso = modulos.Contains(modulo);

            SqlParameter[] parametros = {
            new SqlParameter("@idUsuario", idUsuario),
            new SqlParameter("@modulo", modulo),
            new SqlParameter("@acceso", tieneAcceso ? 1 : 0)
        };

            db.EjecutarConsulta("EXEC SP_Permiso_Actualizar @idUsuario, @modulo, @acceso", parametros);
        }

        return RedirectToAction("Index", new { idUsuario });
    }



}