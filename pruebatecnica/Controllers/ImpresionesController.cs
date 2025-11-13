using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using pruebatecnica.Models;
using System.Data;

[Authorize(Policy = "Impresiones")]
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

        if (imagenFondoFile != null && imagenFondoFile.Length > 0)
        {
            // ✅ Validar tipo MIME
            var tiposPermitidos = new[] { "image/jpeg", "image/png", "image/gif", "image/webp" };
            if (!tiposPermitidos.Contains(imagenFondoFile.ContentType.ToLower()))
            {
                ViewBag.Mensaje = "❌ Solo se permiten imágenes (JPG, PNG, GIF, WEBP).";
                return View("Index");
            }

            // ✅ Validar extensión del archivo
            string extension = Path.GetExtension(imagenFondoFile.FileName).ToLower();
            var extensionesPermitidas = new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" };
            if (!extensionesPermitidas.Contains(extension))
            {
                ViewBag.Mensaje = "❌ Extensión no válida. Solo .jpg, .jpeg, .png, .gif o .webp.";
                return View("Index");
            }

            // 📁 Guardar la imagen en wwwroot/uploads
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

        ViewBag.Mensaje = "✅ Configuración guardada correctamente.";
        return RedirectToAction("Index");
    }
}
