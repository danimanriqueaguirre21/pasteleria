
package org.example.contacto;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;

@Repository
public class ContactoRepository {

    private final JdbcTemplate jdbcTemplate;

    public ContactoRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void guardarMensaje(
            String nombre,
            String correo,
            String asunto,
            String mensaje) {

        String sql = """
                INSERT INTO contacto
                (nombre, correo, asunto, mensaje)
                VALUES (?, ?, ?, ?)
                """;

        jdbcTemplate.update(
                sql,
                nombre,
                correo,
                asunto,
                mensaje
        );
    }

    public List<Contacto> listarMensajes() {
        String sql = """
                SELECT id_contacto, nombre, correo, asunto, mensaje, fecha
                FROM contacto
                ORDER BY fecha DESC, id_contacto DESC
                """;

        RowMapper<Contacto> mapper = (rs, rowNum) -> {
            Contacto contacto = new Contacto();
            contacto.setIdContacto(rs.getInt("id_contacto"));
            contacto.setNombre(rs.getString("nombre"));
            contacto.setCorreo(rs.getString("correo"));
            contacto.setAsunto(rs.getString("asunto"));
            contacto.setMensaje(rs.getString("mensaje"));

            Timestamp fecha = rs.getTimestamp("fecha");
            if (fecha != null) {
                contacto.setFecha(fecha.toLocalDateTime());
            }

            return contacto;
        };

        return jdbcTemplate.query(sql, mapper);
    }
}
