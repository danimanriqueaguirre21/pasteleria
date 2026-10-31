
package org.example.usuario;

import java.util.Collection;
import java.util.List;

public interface UsuarioDAO {

    void registrarUsuario(Usuario usuario);

    Usuario buscarPorCorreo(String correo);

    Usuario obtenerUsuarioPorId(int id);

    List<Usuario> listarPorIds(Collection<Integer> ids);

    List<Usuario> listarUsuarios();

    List<Usuario> listarUsuariosPorRol(String rol);

    void actualizarEstado(int idUsuario, boolean estado);
}
