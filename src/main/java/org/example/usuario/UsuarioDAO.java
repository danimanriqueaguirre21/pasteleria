
package org.example.usuario;

import java.util.List;

public interface UsuarioDAO {

    void registrarUsuario(Usuario usuario);

    Usuario buscarPorCorreo(String correo);

    Usuario obtenerUsuarioPorId(int id);

    int obtenerIdRolPorNombre(String nombre);

    List<Usuario> listarUsuarios();

    List<Usuario> listarUsuariosPorRol(int idRol);

    void actualizarRol(int idUsuario, int idRol);

    void actualizarEstado(int idUsuario, boolean estado);
}
