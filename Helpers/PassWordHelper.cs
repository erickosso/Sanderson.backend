using sanderson.backend.DAL;
using System;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace sanderson.backend.Helpers
{
    public static class PasswordHelper
    {
        // Tamaño del salt (sal) en bytes
        private const int SaltSize = 16;

        // Tamaño del hash en bytes
        private const int HashSize = 20;

        // Número de iteraciones (ajustar según necesidad de seguridad)
        private const int Iterations = 10000;

        // Versión del formato (para futuras actualizaciones)
        private const int Version = 1;

        /// <summary>
        /// Genera un hash de contraseña seguro con salt y formato versionado.
        /// </summary>
        public static string HashPassword(string password)
        {
            // Genera un salt aleatorio
            byte[] salt = new byte[SaltSize];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            // Genera el hash
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations);
            byte[] hash = pbkdf2.GetBytes(HashSize);

            // Combina salt + hash
            byte[] hashBytes = new byte[SaltSize + HashSize];
            Array.Copy(salt, 0, hashBytes, 0, SaltSize);
            Array.Copy(hash, 0, hashBytes, SaltSize, HashSize);

            // Codifica en Base64 y agrega versión e iteraciones
            string base64Hash = Convert.ToBase64String(hashBytes);
            return $"${Version}${Iterations}${base64Hash}";
        }

        /// <summary>
        /// Verifica una contraseña ingresada contra el hash almacenado (nuevo formato).
        /// </summary>
        public static bool VerifyPassword(string password, string storedHash)
        {
            try
            {
                string[] parts = storedHash.Split('$');
                if (parts.Length != 4) return false;

                int version = int.Parse(parts[1]);
                if (version != Version) return false;

                int iterations = int.Parse(parts[2]);
                byte[] hashBytes = Convert.FromBase64String(parts[3]);

                // Extrae el salt
                byte[] salt = new byte[SaltSize];
                Array.Copy(hashBytes, 0, salt, 0, SaltSize);

                // Recalcula el hash de la contraseña ingresada
                var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations);
                byte[] hash = pbkdf2.GetBytes(HashSize);

                // Compara byte a byte
                for (int i = 0; i < HashSize; i++)
                {
                    if (hashBytes[i + SaltSize] != hash[i])
                        return false;
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Verifica una contraseña contra un hash SHA1 (solo para compatibilidad con contraseñas antiguas).
        /// </summary>
        public static bool VerifyLegacyPassword(string enteredPassword, string storedHash)
        {
            using (var sha1 = SHA1.Create())
            {
                byte[] enteredBytes = Encoding.UTF8.GetBytes(enteredPassword);
                byte[] enteredHash = sha1.ComputeHash(enteredBytes);

                string enteredHashString = BitConverter.ToString(enteredHash).Replace("-", "");
                return enteredHashString.Equals(storedHash, StringComparison.OrdinalIgnoreCase);
            }
        }

        /// <summary>
        /// Verifica una contraseña contra cualquier tipo de hash (nuevo o antiguo).
        /// </summary>
        public static bool VerifyAnyPassword(string enteredPassword, string storedHash)
        {
            // Si el hash comienza con "$[número]", es versión nueva
            if (storedHash.StartsWith("$"))
            {
                return VerifyPassword(enteredPassword, storedHash);
            }
            else
            {
                return VerifyLegacyPassword(enteredPassword, storedHash);
            }
        }

        public static bool ChangePassword(EscuelasSandersonSatoriEntities context, Guid usuarioId, string currentPassword, string newPassword)
        {
            var usuario = context.Usuarios
                               .FirstOrDefault(u => u.usuario_id == usuarioId);

            if (usuario == null) return false;

            // Verificar contraseña actual
            if (!VerifyAnyPassword(currentPassword, usuario.password_hash))
            {
                return false;
            }

            // Actualizar contraseña
            usuario.password_hash = HashPassword(newPassword);
            usuario.temp_password = newPassword; // Limpiar contraseña temporal si existe

            context.SaveChanges();
            return true;
        }

        /// <summary>
        /// Cambia la contraseña con confirmación de nueva contraseña
        /// </summary>
        public static bool ChangePasswordWithConfirmation(EscuelasSandersonSatoriEntities context, Guid usuarioId,
            string currentPassword, string newPassword, string confirmPassword)
        {
            if (newPassword != confirmPassword)
                return false;

            return ChangePassword(context, usuarioId, currentPassword, newPassword);
        }

        /// <summary>
        /// Establece una nueva contraseña sin verificar la actual (para admins)
        /// </summary>
        public static bool SetNewPassword(EscuelasSandersonSatoriEntities context, Guid usuarioId, string newPassword)
        {
            var usuario = context.Usuarios
                               .FirstOrDefault(u => u.usuario_id == usuarioId);

            if (usuario == null) return false;

            usuario.password_hash = HashPassword(newPassword);
            usuario.temp_password = newPassword;

            context.SaveChanges();
            return true;
        }

       
    }
}
