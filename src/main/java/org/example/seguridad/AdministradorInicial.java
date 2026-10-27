
package org.example.seguridad;

import org.example.usuario.Usuario;
import org.example.usuario.UsuarioDAO;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@Profile("crear-admin")
public class AdministradorInicial implements CommandLineRunner {

    private final UsuarioDAO usuarioDAO;

    public AdministradorInicial(UsuarioDAO usuarioDAO) {
        this.usuarioDAO = usuarioDAO;
    }

    @Override
    public void run(String... args) {

        String correo = "admin@pasteleria.com";

        if (usuarioDAO.buscarPorCorreo(correo) != null) {
            System.out.println("El administrador ya existe.");
            return;
        }

        String contrasena = System.getenv("PASTELERIA_ADMIN_PASSWORD");

        if (contrasena == null || contrasena.length() < 12) {
            throw new IllegalStateException(
                    "Configura PASTELERIA_ADMIN_PASSWORD " +
                            "con al menos 12 caracteres."
            );
        }

        BCryptPasswordEncoder encoder =
                new BCryptPasswordEncoder();

        Usuario administrador = new Usuario();

        administrador.setNombres("Administrador");
        administrador.setApellidos("Pastelería");
        administrador.setCorreo(correo);
        administrador.setContrasena(encoder.encode(contrasena));
        administrador.setEstado(true);

        int idRol = usuarioDAO.obtenerIdRolPorNombre(
                "ADMINISTRADOR"
        );

        administrador.setIdRol(idRol);

        usuarioDAO.registrarUsuario(administrador);

        System.out.println("Administrador creado correctamente.");
    }
}

