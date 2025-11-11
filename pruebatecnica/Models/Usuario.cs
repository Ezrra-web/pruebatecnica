using System;
using System.ComponentModel.DataAnnotations;
namespace pruebatecnica.Models
{
    public class Usuario
    {
        public int idUsuario { get; set; }

        [Required]
        public string usuario { get; set; }

        [Required]
        public string password { get; set; }

        [Required]
        public string status { get; set; }

        [Required]
        public TimeSpan horarioInicio { get; set; }

        [Required]
        public TimeSpan horarioFin { get; set; }
    }
}
