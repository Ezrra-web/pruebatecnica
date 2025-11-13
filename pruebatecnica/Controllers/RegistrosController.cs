using iTextSharp.text;
using iTextSharp.text.pdf;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using pruebatecnica.Models;
using System.Data;
using System.IO;
using System.IO.Compression;

[Authorize(Policy = "Registro")]
public class RegistrosController : Controller
{
    private readonly ConexionBD db;
    private readonly IWebHostEnvironment _env;

    public RegistrosController(ConexionBD conexion, IWebHostEnvironment env)
    {
        db = conexion;
        _env = env;
    }

    public IActionResult Index()
    {
        DataTable dt = db.EjecutarConsulta("EXEC SP_Registro_Listar");
        return View(dt);
    }

    public IActionResult Crear() => View();

    [HttpPost]
    public IActionResult Crear(string nombre, string contrato, decimal saldo, DateTime fecha, string telefono)
    {
        // 🔤 Validar que el nombre solo tenga letras y espacios
        if (!System.Text.RegularExpressions.Regex.IsMatch(nombre ?? "", @"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$"))
        {
            ViewBag.Mensaje = "❌ El nombre solo puede contener letras y espacios.";
            return View("Crear"); // o la vista que uses
        }

        // 🔐 Validar que el contrato solo tenga letras y números (sin caracteres especiales)
        if (!System.Text.RegularExpressions.Regex.IsMatch(contrato ?? "", @"^[a-zA-Z0-9]+$"))
        {
            ViewBag.Mensaje = "❌ El contrato solo puede contener letras y números, sin caracteres especiales.";
            return View("Crear");
        }

        // 💰 Validar que el saldo no sea negativo
        if (saldo < 0)
        {
            ViewBag.Mensaje = "❌ El saldo no puede ser negativo.";
            return View("Crear");
        }

        // ☎️ Validar que el teléfono solo tenga números
        if (!System.Text.RegularExpressions.Regex.IsMatch(telefono ?? "", @"^[0-9]+$"))
        {
            ViewBag.Mensaje = "❌ El teléfono solo puede contener números.";
            return View("Crear");
        }



        SqlParameter[] parametros =
        {
            new SqlParameter("@nombre", nombre),
            new SqlParameter("@contrato", contrato),
            new SqlParameter("@saldo", saldo),
            new SqlParameter("@fecha", fecha),
            new SqlParameter("@telefono", telefono)
        };
        db.EjecutarConsulta("EXEC SP_Registro_Insertar @nombre, @contrato, @saldo, @fecha, @telefono", parametros);
        SqlParameter[] pHist = {
    new SqlParameter("@idUsuario", Convert.ToInt32(User.FindFirst("idUsuario")?.Value)),
    new SqlParameter("@modulo", "Registro"),
    new SqlParameter("@accion", "Crear"),
    new SqlParameter("@descripcion", $"Creo el registro del contrato {contrato}")
};
        db.EjecutarConsulta("EXEC SP_Historico_Insertar @idUsuario, @modulo, @accion, @descripcion", pHist);

        return RedirectToAction("Index");
    }

    public IActionResult Editar(int id)
    {
        SqlParameter[] p = { new SqlParameter("@idRegistro", id) };
        DataTable dt = db.EjecutarConsulta("EXEC SP_Registro_Buscar @idRegistro", p);
        if (dt.Rows.Count == 0) return RedirectToAction("Index");
        return View(dt.Rows[0]);
    }

    [HttpPost]
    public IActionResult Editar(int idRegistro, string nombre, string contrato, decimal saldo, DateTime fecha, string telefono)
    {
        // 🔤 Validar que el nombre solo tenga letras y espacios
        if (!System.Text.RegularExpressions.Regex.IsMatch(nombre ?? "", @"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$"))
        {
            ViewBag.Mensaje = "❌ El nombre solo puede contener letras y espacios.";
            return View("Crear"); // o la vista que uses
        }

        // 🔐 Validar que el contrato solo tenga letras y números (sin caracteres especiales)
        if (!System.Text.RegularExpressions.Regex.IsMatch(contrato ?? "", @"^[a-zA-Z0-9]+$"))
        {
            ViewBag.Mensaje = "❌ El contrato solo puede contener letras y números, sin caracteres especiales.";
            return View("Crear");
        }

        // 💰 Validar que el saldo no sea negativo
        if (saldo < 0)
        {
            ViewBag.Mensaje = "❌ El saldo no puede ser negativo.";
            return View("Crear");
        }

        // ☎️ Validar que el teléfono solo tenga números
        if (!System.Text.RegularExpressions.Regex.IsMatch(telefono ?? "", @"^[0-9]+$"))
        {
            ViewBag.Mensaje = "❌ El teléfono solo puede contener números.";
            return View("Crear");
        }



        SqlParameter[] p =
        {
            new SqlParameter("@idRegistro", idRegistro),
            new SqlParameter("@nombre", nombre),
            new SqlParameter("@contrato", contrato),
            new SqlParameter("@saldo", saldo),
            new SqlParameter("@fecha", fecha),
            new SqlParameter("@telefono", telefono)
        };
        db.EjecutarConsulta("EXEC SP_Registro_Actualizar @idRegistro, @nombre, @contrato, @saldo, @fecha, @telefono", p);
        SqlParameter[] pHist = {
    new SqlParameter("@idUsuario", Convert.ToInt32(User.FindFirst("idUsuario")?.Value)),
    new SqlParameter("@modulo", "Registro"),
    new SqlParameter("@accion", "Edición"),
    new SqlParameter("@descripcion", $"Modificó registro ID {idRegistro}")
};
        db.EjecutarConsulta("EXEC SP_Historico_Insertar @idUsuario, @modulo, @accion, @descripcion", pHist);

        return RedirectToAction("Index");
    }

    public IActionResult Eliminar(int idUsuario,int id)
    {
        SqlParameter[] p = { new SqlParameter("@idRegistro", id) };
        db.EjecutarConsulta("EXEC SP_Registro_Eliminar @idRegistro", p);
        // 🔹 Registramos en el histórico
        SqlParameter[] pHist = {
            new SqlParameter("@idUsuario", Convert.ToInt32(User.FindFirst("idUsuario")?.Value)),
            new SqlParameter("@modulo", "Registro"),
            new SqlParameter("@accion", "Eliminación"),
            new SqlParameter("@descripcion", $"Eliminó el registro  (ID {id})")
        };

        db.EjecutarConsulta("EXEC SP_Historico_Insertar @idUsuario, @modulo, @accion, @descripcion", pHist);

        return RedirectToAction("Index");
    }
    // 🔹 Generar un solo PDF con configuración de impresión
    public IActionResult GenerarPDF(int id)
    {
        SqlParameter[] parametros = { new SqlParameter("@idRegistro", id) };
        DataTable dt = db.EjecutarConsulta("EXEC SP_Registro_Buscar @idRegistro", parametros);
        if (dt.Rows.Count == 0)
            return RedirectToAction("Index");

        DataRow r = dt.Rows[0];

        // 🔸 Obtener configuración de impresión
        DataTable conf = db.EjecutarConsulta("EXEC SP_Impresion_ObtenerConfig");
        DataRow cfg = conf.Rows.Count > 0 ? conf.Rows[0] : null;

        string tamanoHoja = cfg?["tamanoHoja"]?.ToString() ?? "A4";
        string tipoLetra = cfg?["tipoLetra"]?.ToString() ?? "Helvetica";
        int tamanoLetra = cfg?["tamanoLetra"] != DBNull.Value ? Convert.ToInt32(cfg["tamanoLetra"]) : 12;
        string imagenFondo = cfg?["imagenFondo"]?.ToString();

        Rectangle pageSize = tamanoHoja switch
        {
            "Carta" => PageSize.LETTER,
            "Oficio" => PageSize.LEGAL,
            "A5" => PageSize.A5,
            "Ticket" => new Rectangle(200, 600),
            _ => PageSize.A4
        };

        using (MemoryStream ms = new MemoryStream())
        {
            Document doc = new Document(pageSize, 40, 40, 40, 40);
            PdfWriter writer = PdfWriter.GetInstance(doc, ms);
            doc.Open();

            // 🔸 Imagen de fondo
            if (!string.IsNullOrEmpty(imagenFondo))
            {
                string rutaFondo = Path.Combine(_env.WebRootPath, "uploads", imagenFondo);
                if (System.IO.File.Exists(rutaFondo))
                {
                    Image bg = Image.GetInstance(rutaFondo);
                    bg.SetAbsolutePosition(0, 0);
                    bg.ScaleToFit(pageSize.Width, pageSize.Height);
                    bg.Alignment = Image.UNDERLYING;
                    doc.Add(bg);
                }
            }

            // 🔸 Encabezado
            var titulo = new Paragraph("📄 Registro de Usuario",
                FontFactory.GetFont(tipoLetra, tamanoLetra + 6, Font.BOLD));
            titulo.Alignment = Element.ALIGN_CENTER;
            doc.Add(titulo);
            doc.Add(new Paragraph("\n"));

            // 🔸 Cuerpo
            PdfPTable tabla = new PdfPTable(2);
            tabla.WidthPercentage = 100;
            var font = FontFactory.GetFont(tipoLetra, tamanoLetra, Font.NORMAL);

            tabla.AddCell(new PdfPCell(new Phrase("Nombre", font)));
            tabla.AddCell(new PdfPCell(new Phrase(r["nombre"].ToString(), font)));

            tabla.AddCell(new PdfPCell(new Phrase("Contrato", font)));
            tabla.AddCell(new PdfPCell(new Phrase(r["contrato"].ToString(), font)));

            tabla.AddCell(new PdfPCell(new Phrase("Saldo", font)));
            tabla.AddCell(new PdfPCell(new Phrase(Convert.ToDecimal(r["saldo"]).ToString("C2"), font)));

            tabla.AddCell(new PdfPCell(new Phrase("Fecha", font)));
            tabla.AddCell(new PdfPCell(new Phrase(Convert.ToDateTime(r["fecha"]).ToString("dd/MM/yyyy"), font)));

            tabla.AddCell(new PdfPCell(new Phrase("Teléfono", font)));
            tabla.AddCell(new PdfPCell(new Phrase(r["telefono"].ToString(), font)));

            doc.Add(tabla);
            doc.Close();

            byte[] bytes = ms.ToArray();
            return File(bytes, "application/pdf", $"Registro_{r["idRegistro"]}.pdf");
        }
    }

    // 🔹 Generar ZIP con varios PDFs aplicando la misma configuración
    [HttpPost]
    public IActionResult DescargarMultiplesPDF(int[] idsSeleccionados)
    {
        if (idsSeleccionados == null || idsSeleccionados.Length == 0)
            return RedirectToAction("Index");

        // 🔸 Obtener configuración de impresión
        DataTable conf = db.EjecutarConsulta("EXEC SP_Impresion_ObtenerConfig");
        DataRow cfg = conf.Rows.Count > 0 ? conf.Rows[0] : null;

        string tamanoHoja = cfg?["tamanoHoja"]?.ToString() ?? "A4";
        string tipoLetra = cfg?["tipoLetra"]?.ToString() ?? "Helvetica";
        int tamanoLetra = cfg?["tamanoLetra"] != DBNull.Value ? Convert.ToInt32(cfg["tamanoLetra"]) : 12;
        string imagenFondo = cfg?["imagenFondo"]?.ToString();

        Rectangle pageSize = tamanoHoja switch
        {
            "Carta" => PageSize.LETTER,
            "Oficio" => PageSize.LEGAL,
            "A5" => PageSize.A5,
            "Ticket" => new Rectangle(200, 600),
            _ => PageSize.A4
        };

        using (MemoryStream zipStream = new MemoryStream())
        {
            using (var archive = new ZipArchive(zipStream, ZipArchiveMode.Create, true))
            {
                foreach (int id in idsSeleccionados)
                {
                    SqlParameter[] parametros = { new SqlParameter("@idRegistro", id) };
                    DataTable dt = db.EjecutarConsulta("EXEC SP_Registro_Buscar @idRegistro", parametros);
                    if (dt.Rows.Count == 0) continue;

                    DataRow r = dt.Rows[0];

                    using (MemoryStream pdfStream = new MemoryStream())
                    {
                        Document doc = new Document(pageSize, 40, 40, 40, 40);
                        PdfWriter.GetInstance(doc, pdfStream);
                        doc.Open();

                        // Fondo
                        if (!string.IsNullOrEmpty(imagenFondo))
                        {
                            string rutaFondo = Path.Combine(_env.WebRootPath, "uploads", imagenFondo);
                            if (System.IO.File.Exists(rutaFondo))
                            {
                                Image bg = Image.GetInstance(rutaFondo);
                                bg.SetAbsolutePosition(0, 0);
                                bg.ScaleToFit(pageSize.Width, pageSize.Height);
                                bg.Alignment = Image.UNDERLYING;
                                doc.Add(bg);
                            }
                        }

                        // Contenido
                        var font = FontFactory.GetFont(tipoLetra, tamanoLetra, Font.NORMAL);
                        doc.Add(new Paragraph("📄 Registro de Usuario", FontFactory.GetFont(tipoLetra, tamanoLetra + 6, Font.BOLD)));
                        doc.Add(new Paragraph("\n"));

                        PdfPTable tabla = new PdfPTable(2);
                        tabla.WidthPercentage = 100;

                        tabla.AddCell(new Phrase("Nombre", font));
                        tabla.AddCell(new Phrase(r["nombre"].ToString(), font));
                        tabla.AddCell(new Phrase("Contrato", font));
                        tabla.AddCell(new Phrase(r["contrato"].ToString(), font));
                        tabla.AddCell(new Phrase("Saldo", font));
                        tabla.AddCell(new Phrase(Convert.ToDecimal(r["saldo"]).ToString("C2"), font));
                        tabla.AddCell(new Phrase("Fecha", font));
                        tabla.AddCell(new Phrase(Convert.ToDateTime(r["fecha"]).ToString("dd/MM/yyyy"), font));
                        tabla.AddCell(new Phrase("Teléfono", font));
                        tabla.AddCell(new Phrase(r["telefono"].ToString(), font));

                        doc.Add(tabla);
                        doc.Close();

                        // Agregar al ZIP
                        var entry = archive.CreateEntry($"Registro_{id}.pdf");
                        using (var entryStream = entry.Open())
                        {
                            var pdfBytes = pdfStream.ToArray();
                            entryStream.Write(pdfBytes, 0, pdfBytes.Length);
                        }
                    }
                }
            }

            zipStream.Position = 0;
            return File(zipStream.ToArray(), "application/zip", "RegistrosSeleccionados.zip");
        }
    }
}
