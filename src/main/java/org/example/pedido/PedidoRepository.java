
package org.example.pedido;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Types;
import java.util.List;

@Repository
public class PedidoRepository implements PedidoDAO {

    private final JdbcTemplate jdbcTemplate;

    public PedidoRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private static final String SELECT_DETALLES = """
            SELECT d.id_detalle, d.id_pedido, d.id_producto, d.cantidad,
                   d.precio_unitario, d.subtotal, p.nombre AS nombre_producto
            FROM detalle_pedido d
            LEFT JOIN producto p ON p.id_producto = d.id_producto
            """;

    private final RowMapper<Pedido> pedidoRowMapper = new PedidoRowMapper();

    private final RowMapper<DetallePedido> detalleRowMapper = (rs, rowNum) -> {

        DetallePedido detalle = new DetallePedido();

        detalle.setIdDetalle(rs.getInt("id_detalle"));
        detalle.setIdPedido(rs.getInt("id_pedido"));
        detalle.setIdProducto(rs.getInt("id_producto"));
        detalle.setCantidad(rs.getInt("cantidad"));
        detalle.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
        detalle.setSubtotal(rs.getBigDecimal("subtotal"));
        detalle.setNombreProducto(rs.getString("nombre_producto"));

        return detalle;
    };

    @Override
    public int registrarPedido(Pedido pedido) {

        String sql = """
                INSERT INTO pedido (
                    id_usuario,
                    direccion_entrega,
                    telefono,
                    total,
                    estado,
                    medio_pago,
                    id_repartidor,
                    codigo_seguimiento
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;

        KeyHolder keyHolder = new GeneratedKeyHolder();

        int filasInsertadas = jdbcTemplate.update(connection -> {

            PreparedStatement ps = connection.prepareStatement(
                    sql,
                    new String[]{"ID_PEDIDO"}
            );

            ps.setInt(1, pedido.getIdUsuario());
            ps.setString(2, pedido.getDireccionEntrega());
            ps.setString(3, pedido.getTelefono());
            ps.setBigDecimal(4, pedido.getTotal());
            ps.setString(5, pedido.getEstado());
            ps.setString(6, pedido.getMedioPago());

            if (pedido.getIdRepartidor() == null) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, pedido.getIdRepartidor());
            }

            ps.setString(8, pedido.getCodigoSeguimiento());

            return ps;

        }, keyHolder);

        if (filasInsertadas != 1) {
            throw new IllegalStateException(
                    "No se pudo registrar el pedido"
            );
        }

        if (keyHolder.getKey() == null) {
            throw new IllegalStateException(
                    "No se pudo obtener el ID del pedido"
            );
        }

        return keyHolder.getKey().intValue();
    }

    @Override
    public void registrarDetalle(DetallePedido detalle) {

        String sql = """
                INSERT INTO detalle_pedido (
                    id_pedido,
                    id_producto,
                    cantidad,
                    precio_unitario,
                    subtotal
                )
                VALUES (?, ?, ?, ?, ?)
                """;

        int filasInsertadas = jdbcTemplate.update(
                sql,
                detalle.getIdPedido(),
                detalle.getIdProducto(),
                detalle.getCantidad(),
                detalle.getPrecioUnitario(),
                detalle.getSubtotal()
        );

        if (filasInsertadas != 1) {
            throw new IllegalStateException(
                    "No se pudo registrar un producto del pedido"
            );
        }
    }

    @Override
    public Pedido obtenerPedidoPorId(int idPedido) {

        String sql = """
                SELECT *
                FROM pedido
                WHERE id_pedido = ?
                """;

        List<Pedido> resultados = jdbcTemplate.query(
                sql,
                pedidoRowMapper,
                idPedido
        );

        return resultados.isEmpty() ? null : resultados.get(0);
    }

    @Override
    public List<Pedido> listarPedidosPorUsuario(int idUsuario) {

        String sql = """
                SELECT *
                FROM pedido
                WHERE id_usuario = ?
                ORDER BY fecha_pedido DESC, id_pedido DESC
                """;

        return jdbcTemplate.query(
                sql,
                pedidoRowMapper,
                idUsuario
        );
    }

    @Override
    public List<DetallePedido> listarDetallesPorPedido(int idPedido) {

        String sql = SELECT_DETALLES
                + "WHERE d.id_pedido = ? ORDER BY d.id_detalle";

        return jdbcTemplate.query(
                sql,
                detalleRowMapper,
                idPedido
        );
    }

    @Override
    public List<DetallePedido> listarTodosLosDetalles() {
        String sql = SELECT_DETALLES
                + "ORDER BY d.id_pedido, d.id_detalle";

        return jdbcTemplate.query(sql, detalleRowMapper);
    }

    @Override
    public List<Pedido> listarTodosLosPedidos() {

        String sql = """
                SELECT *
                FROM pedido
                ORDER BY fecha_pedido DESC, id_pedido DESC
                """;

        return jdbcTemplate.query(
                sql,
                pedidoRowMapper
        );
    }

    @Override
    public Pedido obtenerPedidoPorCodigoSeguimiento(
            String codigoSeguimiento) {

        String sql = """
                SELECT *
                FROM pedido
                WHERE codigo_seguimiento = ?
                """;

        List<Pedido> resultados = jdbcTemplate.query(
                sql,
                pedidoRowMapper,
                codigoSeguimiento
        );

        return resultados.isEmpty() ? null : resultados.get(0);
    }

    @Override
    public String obtenerEstadoBloqueado(int idPedido) {
        String sql = """
            SELECT estado
            FROM pedido
            WHERE id_pedido = ?
            FOR UPDATE
            """;

        List<String> estados = jdbcTemplate.query(
                sql,
                (rs, rowNum) -> rs.getString("estado"),
                idPedido
        );

        return estados.isEmpty() ? null : estados.get(0);
    }

    @Override
    public int actualizarEstadoPedido(
            int idPedido,
            String estadoActual,
            String nuevoEstado) {

        String sql = """
            UPDATE pedido
            SET estado = ?
            WHERE id_pedido = ?
              AND estado = ?
            """;

        return jdbcTemplate.update(
                sql,
                nuevoEstado,
                idPedido,
                estadoActual
        );
    }

    @Override
    public Pedido obtenerDatosCancelacionBloqueado(int idPedido) {
        String sql = """
            SELECT id_pedido, id_usuario, estado
            FROM pedido
            WHERE id_pedido = ?
            FOR UPDATE
            """;

        List<Pedido> resultado = jdbcTemplate.query(
                sql,
                (rs, rowNum) -> {
                    Pedido pedido = new Pedido();
                    pedido.setIdPedido(rs.getInt("id_pedido"));
                    pedido.setIdUsuario(rs.getInt("id_usuario"));
                    pedido.setEstado(rs.getString("estado"));
                    return pedido;
                },
                idPedido
        );

        return resultado.isEmpty() ? null : resultado.get(0);
    }

    @Override
    public int cancelarPedido(int idPedido, int idUsuario) {
        String sql = """
            UPDATE pedido
            SET estado = 'CANCELADO'
            WHERE id_pedido = ?
              AND id_usuario = ?
              AND estado = 'RECIBIDO'
            """;

        return jdbcTemplate.update(sql, idPedido, idUsuario);
    }

    @Override
    public void registrarFechaEntrega(int idPedido) {
        String sql = """
                UPDATE pedido
                SET fecha_entrega = CURRENT_TIMESTAMP
                WHERE id_pedido = ?
                """;

        jdbcTemplate.update(sql, idPedido);
    }

}
