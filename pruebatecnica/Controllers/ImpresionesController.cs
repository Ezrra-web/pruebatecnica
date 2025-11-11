using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using pruebatecnica.Models;
using Microsoft.Data.SqlClient;
using System.Data;

[Authorize]
public class ImpresionesController : Controller
{
    private readonly ConexionBD db;

    public ImpresionesController(ConexionBD conexion)
    {
        db = conexion;
    }

    private bool TienePermiso()
    {
        return User.Claims.Any(c => c.Type == "permiso" && c.Value == "Impresiones");
    }

    public IActionResult Index()
    {
        if (!TienePermiso())
            return Unauthorized();

        DataTable dt = db.EjecutarConsulta("EXEC SP_Impresion_Obtener");
        if (dt.Rows.Count == 0)
            return View();

        return View(dt.Rows[0]);
    }

    [HttpPost]
    public IActionResult Guardar(string tamanoHoja, string tipoLetra, int tamanoLetra, IFormFile? imagenFondoFile)
    {
        string nombreArchivo = null;

        // 📁 Guardar imagen si se sube una nueva
        if (imagenFondoFile != null && imagenFondoFile.Length > 0)
        {
            string uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads");

            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            nombreArchivo = Path.GetFileName(imagenFondoFile.FileName);
            string filePath = Path.Combine(uploadsFolder, nombreArchivo);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                imagenFondoFile.CopyTo(stream);
            }
        }

        SqlParameter[] parametros =
        {
        new SqlParameter("@tamanoHoja", tamanoHoja),
        new SqlParameter("@tipoLetra", tipoLetra),
        new SqlParameter("@tamanoLetra", tamanoLetra),
        new SqlParameter("@imagenFondo", (object?)nombreArchivo ?? DBNull.Value)
    };

        db.EjecutarConsulta("EXEC SP_Impresion_Guardar @tamanoHoja, @tipoLetra, @tamanoLetra, @imagenFondo", parametros);

        return RedirectToAction("Index");
    }

}
