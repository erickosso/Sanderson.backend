using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace sanderson.backend.Models
{
    public class UsuarioDto
    {
        public Guid IdUsuario { get; set; }
        public string Nombre { get; set; }
        public string NombreUsuario { get; set; }
        public string NombreRol { get; set; }
        public Guid? IdEscuela { get; set; }
    }

}