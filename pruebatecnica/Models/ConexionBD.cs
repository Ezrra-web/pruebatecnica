
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace pruebatecnica.Models
{
    public class ConexionBD
    {
        private readonly string cadenaConexion;

        public ConexionBD(IConfiguration configuration)
        {
            cadenaConexion = configuration.GetConnectionString("MiConexion");
        }

        private SqlConnection ObtenerConexion() => new SqlConnection(cadenaConexion);

        public DataTable EjecutarConsulta(string query, SqlParameter[] parametros = null)
        {
            DataTable tabla = new DataTable();

            using (SqlConnection conexion = ObtenerConexion())
            using (SqlCommand comando = new SqlCommand(query, conexion))
            {
                if (parametros != null)
                {
                    comando.Parameters.AddRange(parametros);
                }

                conexion.Open();
                using (SqlDataAdapter adaptador = new SqlDataAdapter(comando))
                {
                    adaptador.Fill(tabla);
                }
            }

            return tabla;
        }

        public int EjecutarComando(string query, SqlParameter[] parametros = null)
        {
            int filasAfectadas = 0;

            using (SqlConnection conexion = ObtenerConexion())
            using (SqlCommand comando = new SqlCommand(query, conexion))
            {
                if (parametros != null)
                {
                    comando.Parameters.AddRange(parametros);
                }

                conexion.Open();
                filasAfectadas = comando.ExecuteNonQuery();
            }

            return filasAfectadas;
        }

        public object EjecutarEscalar(string query, SqlParameter[] parametros = null)
        {
            object resultado;

            using (SqlConnection conexion = ObtenerConexion())
            using (SqlCommand comando = new SqlCommand(query, conexion))
            {
                if (parametros != null)
                {
                    comando.Parameters.AddRange(parametros);
                }

                conexion.Open();
                resultado = comando.ExecuteScalar();
            }

            return resultado;
        }

        public bool ProbarConexion()
        {
            try
            {
                using (SqlConnection conexion = ObtenerConexion())
                {
                    conexion.Open();
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}
