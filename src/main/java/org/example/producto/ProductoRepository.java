
package org.example.producto;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ProductoRepository implements ProductoDAO {

    private final JdbcTemplate jdbcTemplate;

    public ProductoRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Producto> productoRowMapper =
            (rs, rowNum) -> new Producto(
                    rs.getInt("id_producto"),
                    rs.getString("nombre"),
                    rs.getString("descripcion"),
                    rs.getBigDecimal("precio"),
                    rs.getInt("stock"),
                    rs.getString("imagen"),
                    rs.getBoolean("estado"),
                    rs.getInt("id_categoria")
            );

    @Override
    public List<Producto> listarProductos() {
        String sql = "SELECT * FROM producto ORDER BY id_producto";
        return jdbcTemplate.query(sql, productoRowMapper);
    }

    @Override
    public List<Producto> listarProductosActivos() {

        String sql = """
            SELECT *
            FROM producto
            WHERE estado = TRUE
            ORDER BY id_producto
            """;

        return jdbcTemplate.query(sql, productoRowMapper);
    }

    @Override
    public Producto obtenerProductoPorId(int id) {
        String sql = "SELECT * FROM producto WHERE id_producto = ?";

        List<Producto> resultado =
                jdbcTemplate.query(sql, productoRowMapper, id);

        if (resultado.isEmpty()) {
            return null;
        }

        return resultado.get(0);
    }

    @Override
    public void crearProducto(Producto producto) {
        String sql = """
                INSERT INTO producto
                (nombre, descripcion, precio, stock, imagen, estado, id_categoria)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        jdbcTemplate.update(
                sql,
                producto.getNombre(),
                producto.getDescripcion(),
                producto.getPrecio(),
                producto.getStock(),
                producto.getImagen(),
                producto.isEstado(),
                producto.getIdCategoria()
        );
    }

    @Override
    public void actualizarProducto(Producto producto) {
        String sql = """
                UPDATE producto
                SET nombre = ?, descripcion = ?, precio = ?,
                    stock = ?, imagen = ?, estado = ?, id_categoria = ?
                WHERE id_producto = ?
                """;

        jdbcTemplate.update(
                sql,
                producto.getNombre(),
                producto.getDescripcion(),
                producto.getPrecio(),
                producto.getStock(),
                producto.getImagen(),
                producto.isEstado(),
                producto.getIdCategoria(),
                producto.getIdProducto()
        );
    }

    @Override
    public void desactivarProducto(int id) {
        String sql = "UPDATE producto SET estado = FALSE WHERE id_producto = ?";
        jdbcTemplate.update(sql, id);
    }

    @Override
    public Producto obtenerProductoParaPedido(int id) {
        String sql = """
        SELECT *
        FROM producto
        WHERE id_producto = ?
        FOR UPDATE
        """;

        List<Producto> resultado =
                jdbcTemplate.query(sql, productoRowMapper, id);

        return resultado.isEmpty() ? null : resultado.get(0);
    }

    @Override
    public boolean descontarStock(int idProducto, int cantidad) {
        String sql = """
        UPDATE producto
        SET stock = stock - ?
        WHERE id_producto = ?
          AND stock >= ?
          AND estado = TRUE
        """;

        return jdbcTemplate.update(
                sql, cantidad, idProducto, cantidad
        ) > 0;
    }

    @Override
    public int aumentarStock(int idProducto, int cantidad) {
        String sql = """
            UPDATE producto
            SET stock = stock + ?
            WHERE id_producto = ?
            """;

        return jdbcTemplate.update(sql, cantidad, idProducto);
    }
}
