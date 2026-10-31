
package org.example.usuario;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

@Repository
public class UsuarioRepository implements UsuarioDAO {

    private final JdbcTemplate jdbcTemplate;

    public UsuarioRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Usuario> usuarioRowMapper = (rs, rowNum) -> new Usuario(
            rs.getInt("id_usuario"),
            rs.getString("nombres"),
            rs.getString("apellidos"),
            rs.getString("correo"),
            rs.getString("contrasena"),
            rs.getBoolean("estado"),
            rs.getString("rol")
    );

    @Override
    public void registrarUsuario(Usuario usuario) {
        String sql = "INSERT INTO usuario (nombres, apellidos, correo, contrasena, estado, rol) VALUES (?, ?, ?, ?, ?, ?)";

        jdbcTemplate.update(sql,
                usuario.getNombres(),
                usuario.getApellidos(),
                usuario.getCorreo(),
                usuario.getContrasena(),
                usuario.isEstado(),
                usuario.getRol());
    }

    @Override
    public Usuario buscarPorCorreo(String correo) {
        String sql = "SELECT * FROM usuario WHERE correo = ?";
        List<Usuario> resultado = jdbcTemplate.query(sql, usuarioRowMapper, correo);
        return resultado.isEmpty() ? null : resultado.get(0);
    }

    @Override
    public Usuario obtenerUsuarioPorId(int id) {
        String sql = "SELECT * FROM usuario WHERE id_usuario = ?";
        List<Usuario> resultado = jdbcTemplate.query(sql, usuarioRowMapper, id);
        return resultado.isEmpty() ? null : resultado.get(0);
    }

    @Override
    public List<Usuario> listarPorIds(Collection<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyList();
        }

        String marcadores = "?";

        for (int i = 1; i < ids.size(); i++) {
            marcadores = marcadores + ",?";
        }

        String sql = "SELECT * FROM usuario WHERE id_usuario IN (" + marcadores + ")";

        return jdbcTemplate.query(sql, usuarioRowMapper, ids.toArray());
    }

    @Override
    public List<Usuario> listarUsuarios() {
        String sql = "SELECT * FROM usuario ORDER BY id_usuario DESC";
        return jdbcTemplate.query(sql, usuarioRowMapper);
    }

    @Override
    public List<Usuario> listarUsuariosPorRol(String rol) {
        String sql = "SELECT * FROM usuario WHERE rol = ? ORDER BY id_usuario DESC";
        return jdbcTemplate.query(sql, usuarioRowMapper, rol);
    }

    @Override
    public void actualizarEstado(int idUsuario, boolean estado) {
        String sql = "UPDATE usuario SET estado = ? WHERE id_usuario = ?";
        jdbcTemplate.update(sql, estado, idUsuario);
    }
}
