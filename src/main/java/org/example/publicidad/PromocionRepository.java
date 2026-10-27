package org.example.publicidad;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class PromocionRepository implements PromocionDAO {

    private final JdbcTemplate jdbcTemplate;

    public PromocionRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Promocion> promocionRowMapper =
            (rs, rowNum) -> new Promocion(
                    rs.getInt("id_promocion"),
                    rs.getString("titulo"),
                    rs.getString("descripcion"),
                    rs.getString("imagen"),
                    rs.getBoolean("estado")
            );

    @Override
    public List<Promocion> listarPromociones() {
        String sql = "SELECT * FROM promocion ORDER BY id_promocion";
        return jdbcTemplate.query(sql, promocionRowMapper);
    }

    @Override
    public List<Promocion> listarPromocionesActivas() {
        String sql = """
                SELECT * FROM promocion
                WHERE estado = TRUE
                ORDER BY id_promocion
                """;
        return jdbcTemplate.query(sql, promocionRowMapper);
    }

    @Override
    public Promocion obtenerPromocionPorId(int id) {
        String sql = "SELECT * FROM promocion WHERE id_promocion = ?";

        List<Promocion> resultado =
                jdbcTemplate.query(sql, promocionRowMapper, id);

        if (resultado.isEmpty()) {
            return null;
        }

        return resultado.get(0);
    }

    @Override
    public void crearPromocion(Promocion promocion) {
        String sql = """
                INSERT INTO promocion (titulo, descripcion, imagen, estado)
                VALUES (?, ?, ?, ?)
                """;

        jdbcTemplate.update(
                sql,
                promocion.getTitulo(),
                promocion.getDescripcion(),
                promocion.getImagen(),
                promocion.isEstado()
        );
    }

    @Override
    public void actualizarPromocion(Promocion promocion) {
        String sql = """
                UPDATE promocion
                SET titulo = ?, descripcion = ?, imagen = ?, estado = ?
                WHERE id_promocion = ?
                """;

        jdbcTemplate.update(
                sql,
                promocion.getTitulo(),
                promocion.getDescripcion(),
                promocion.getImagen(),
                promocion.isEstado(),
                promocion.getIdPromocion()
        );
    }

    @Override
    public void desactivarPromocion(int id) {
        String sql = "UPDATE promocion SET estado = FALSE WHERE id_promocion = ?";
        jdbcTemplate.update(sql, id);
    }
}
