package org.example.seguridad;

import org.example.usuario.Usuario;
import org.example.usuario.UsuarioService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("crear-admin")
public class AdministradorInicial implements CommandLineRunner {

    private final UsuarioService usuarioService;

    public AdministradorInicial(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @Override
    public void run(String... args) {

        String correo = "admin@pasteleria.com";

        if (usuarioService.existeCorreo(correo)) {
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

        Usuario administrador = new Usuario();

        administrador.setNombres("Administrador");
        administrador.setApellidos("Pastelería");
        administrador.setCorreo(correo);
        administrador.setContrasena(contrasena);

        usuarioService.registrarAdministrador(administrador);

        System.out.println("Administrador creado correctamente.");
    }
}
