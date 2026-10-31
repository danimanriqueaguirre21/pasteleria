package org.example.usuario;

import java.util.Collection;
import java.util.List;

public interface UsuarioService {

    void registrarUsuario(Usuario usuario);

    void registrarAdministrador(Usuario usuario);

    void registrarEmpleado(Usuario usuario, String rol);

    Usuario iniciarSesion(String correo, String contrasena);

    Usuario obtenerUsuarioPorId(int id);

    Usuario buscarPorCorreo(String correo);

    boolean existeCorreo(String correo);

    List<Usuario> buscarPorIds(Collection<Integer> ids);

    List<Usuario> listarUsuarios();

    List<Usuario> listarUsuariosPorRol(String rol);

    List<Usuario> listarActivosPorRol(String nombreRol);

    void actualizarEstado(int idUsuario, boolean estado);

    boolean tieneRol(Integer idUsuario, String nombreRol);
}
