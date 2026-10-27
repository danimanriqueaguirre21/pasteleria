
package org.example.usuario;

import java.util.List;

public interface UsuarioService {

    void registrarUsuario(Usuario usuario);

    Usuario iniciarSesion(String correo, String contrasena);

    Usuario obtenerUsuarioPorId(int id);

    void registrarEmpleado(Usuario usuario, String rol);

    List<Usuario> listarUsuarios();

    List<Usuario> listarUsuariosPorRol(int idRol);

    void actualizarEstado(int idUsuario, boolean estado);

    boolean tieneRol(Integer idUsuario, String nombreRol);

    int obtenerIdRol(String nombreRol);

    List<Usuario> listarActivosPorRol(String nombreRol);
}
