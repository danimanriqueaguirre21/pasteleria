
package org.example.usuario;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Service
public class UsuarioServiceImpl implements UsuarioService {

    private final UsuarioDAO usuarioDAO;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public UsuarioServiceImpl(UsuarioDAO usuarioDAO) {
        this.usuarioDAO = usuarioDAO;
    }

    @Override
    public void registrarUsuario(Usuario usuario) {
        validarDatosUsuario(usuario);
        prepararUsuario(usuario, usuarioDAO.obtenerIdRolPorNombre("CLIENTE"));
        usuarioDAO.registrarUsuario(usuario);
    }

    @Override
    public void registrarEmpleado(Usuario usuario, String rol) {
        if (rol == null) {
            throw new IllegalArgumentException("Debe seleccionar un rol");
        }

        String rolNormalizado = rol.trim().toUpperCase(Locale.ROOT);

        if (!rolNormalizado.equals("CAJERO") && !rolNormalizado.equals("REPARTIDOR")) {
            throw new IllegalArgumentException("Solo se permite registrar cajeros y repartidores");
        }

        validarDatosUsuario(usuario);

        int idRol = usuarioDAO.obtenerIdRolPorNombre(rolNormalizado);
        prepararUsuario(usuario, idRol);
        usuarioDAO.registrarUsuario(usuario);
    }

    private void validarDatosUsuario(Usuario usuario) {
        if (usuario == null) {
            throw new IllegalArgumentException("Los datos del usuario son obligatorios");
        }

        if (usuario.getNombres() == null || usuario.getNombres().isBlank()) {
            throw new IllegalArgumentException("Los nombres son obligatorios");
        }

        if (usuario.getApellidos() == null || usuario.getApellidos().isBlank()) {
            throw new IllegalArgumentException("Los apellidos son obligatorios");
        }

        if (usuario.getCorreo() == null ||
                !usuario.getCorreo().trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            throw new IllegalArgumentException("Ingrese un correo válido");
        }

        if (usuario.getContrasena() == null || usuario.getContrasena().length() < 8) {
            throw new IllegalArgumentException("La contraseña debe tener al menos 8 caracteres");
        }

        String correo = usuario.getCorreo().trim().toLowerCase(Locale.ROOT);

        if (usuarioDAO.buscarPorCorreo(correo) != null) {
            throw new IllegalArgumentException("El correo ya está registrado");
        }
    }

    private void prepararUsuario(Usuario usuario, int idRol) {
        usuario.setNombres(usuario.getNombres().trim());
        usuario.setApellidos(usuario.getApellidos().trim());
        usuario.setCorreo(usuario.getCorreo().trim().toLowerCase(Locale.ROOT));
        usuario.setContrasena(passwordEncoder.encode(usuario.getContrasena()));
        usuario.setEstado(true);
        usuario.setIdRol(idRol);
    }

    @Override
    public Usuario iniciarSesion(String correo, String contrasena) {
        if (correo == null || contrasena == null) {
            return null;
        }

        Usuario usuario = usuarioDAO.buscarPorCorreo(correo.trim().toLowerCase(Locale.ROOT));

        if (usuario == null || !usuario.isEstado()) {
            return null;
        }

        if (!passwordEncoder.matches(contrasena, usuario.getContrasena())) {
            return null;
        }

        return usuario;
    }

    @Override
    public Usuario obtenerUsuarioPorId(int id) {
        return usuarioDAO.obtenerUsuarioPorId(id);
    }

    @Override
    public List<Usuario> listarUsuarios() {
        return usuarioDAO.listarUsuarios();
    }

    @Override
    public List<Usuario> listarUsuariosPorRol(int idRol) {
        return usuarioDAO.listarUsuariosPorRol(idRol);
    }

    @Override
    public void actualizarEstado(int idUsuario, boolean estado) {
        Usuario usuario = usuarioDAO.obtenerUsuarioPorId(idUsuario);

        if (usuario == null) {
            throw new IllegalArgumentException("El usuario no existe");
        }

        int idAdministrador = usuarioDAO.obtenerIdRolPorNombre("ADMINISTRADOR");

        if (usuario.getIdRol() != null && usuario.getIdRol() == idAdministrador) {
            throw new IllegalArgumentException(
                    "No se permite cambiar el estado de una cuenta administradora desde este módulo"
            );
        }

        usuarioDAO.actualizarEstado(idUsuario, estado);
    }

    @Override
    public boolean tieneRol(Integer idUsuario, String nombreRol) {
        if (idUsuario == null) {
            return false;
        }

        Usuario usuario = usuarioDAO.obtenerUsuarioPorId(idUsuario);

        if (usuario == null || !usuario.isEstado() || usuario.getIdRol() == null) {
            return false;
        }

        return usuario.getIdRol().equals(obtenerIdRol(nombreRol));
    }

    @Override
    public int obtenerIdRol(String nombreRol) {
        return usuarioDAO.obtenerIdRolPorNombre(nombreRol);
    }

    @Override
    public List<Usuario> listarActivosPorRol(String nombreRol) {
        List<Usuario> activos = new ArrayList<>();

        for (Usuario usuario : usuarioDAO.listarUsuariosPorRol(obtenerIdRol(nombreRol))) {
            if (usuario.isEstado()) {
                activos.add(usuario);
            }
        }

        return activos;
    }
}
