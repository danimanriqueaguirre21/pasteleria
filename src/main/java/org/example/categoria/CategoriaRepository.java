
package org.example.categoria;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CategoriaRepository implements CategoriaDAO {

    private final JdbcTemplate jdbcTemplate;

    public CategoriaRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Categoria> categoriaRowMapper =
            (rs, rowNum) -> new Categoria(
                    rs.getInt("id_categoria"),
                    rs.getString("nombre"),
                    rs.getString("descripcion"),
                    rs.getBoolean("estado")
            );

    @Override
    public List<Categoria> listarCategorias() {
        String sql = "SELECT * FROM categoria";
        return jdbcTemplate.query(sql, categoriaRowMapper);
    }

    @Override
    public Categoria obtenerCategoriaPorId(int id) {
        String sql = "SELECT * FROM categoria WHERE id_categoria = ?";

        List<Categoria> resultado =
                jdbcTemplate.query(sql, categoriaRowMapper, id);

        if (resultado.isEmpty()) {
            return null;
        }

        return resultado.get(0);
    }

    @Override
    public void crearCategoria(Categoria categoria) {
        String sql = "INSERT INTO categoria (nombre, descripcion, estado) VALUES (?, ?, ?)";

        jdbcTemplate.update(
                sql,
                categoria.getNombre(),
                categoria.getDescripcion(),
                categoria.isEstado()
        );
    }

    @Override
    public void actualizarCategoria(Categoria categoria) {
        String sql = "UPDATE categoria SET nombre = ?, descripcion = ?, estado = ? WHERE id_categoria = ?";

        jdbcTemplate.update(
                sql,
                categoria.getNombre(),
                categoria.getDescripcion(),
                categoria.isEstado(),
                categoria.getIdCategoria()
        );
    }

    @Override
    public void desactivarCategoria(int id) {
        String sql = "UPDATE categoria SET estado = FALSE WHERE id_categoria = ?";

        jdbcTemplate.update(sql, id);
    }
}
