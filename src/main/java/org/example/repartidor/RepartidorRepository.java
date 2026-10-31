
package org.example.repartidor;

import org.example.pedido.Pedido;
import org.example.pedido.PedidoRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RepartidorRepository implements RepartidorDAO {

    private final JdbcTemplate jdbcTemplate;

    private final PedidoRowMapper pedidoRowMapper =
            new PedidoRowMapper();

    public RepartidorRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public Pedido obtenerAsignacionBloqueada(int idPedido) {
        String sql = """
                SELECT id_pedido, estado, id_repartidor
                FROM pedido
                WHERE id_pedido = ?
                FOR UPDATE
                """;

        List<Pedido> pedidos = jdbcTemplate.query(sql, (rs, rowNum) -> {
            Pedido pedido = new Pedido();
            pedido.setIdPedido(rs.getInt("id_pedido"));
            pedido.setEstado(rs.getString("estado"));

            int idRepartidor = rs.getInt("id_repartidor");
            pedido.setIdRepartidor(
                    rs.wasNull() ? null : idRepartidor
            );

            return pedido;
        }, idPedido);

        return pedidos.isEmpty() ? null : pedidos.get(0);
    }

    @Override
    public List<Pedido> listarPedidosPorRepartidor(int idRepartidor) {
        String sql = """
                SELECT id_pedido, id_usuario, fecha_pedido, fecha_entrega,
                       direccion_entrega, telefono, total, estado,
                       medio_pago, id_repartidor, codigo_seguimiento
                FROM pedido
                WHERE id_repartidor = ?
                  AND estado IN ('ASIGNADO', 'EN CAMINO', 'ENTREGADO')
                ORDER BY fecha_pedido DESC, id_pedido DESC
                """;

        return jdbcTemplate.query(sql, pedidoRowMapper, idRepartidor);
    }

    @Override
    public int contarPedidosEnCamino(int idRepartidor) {
        String sql = """
                SELECT COUNT(*)
                FROM pedido
                WHERE id_repartidor = ?
                  AND estado = 'EN CAMINO'
                """;

        Integer total = jdbcTemplate.queryForObject(sql, Integer.class, idRepartidor);
        return total == null ? 0 : total;
    }

    @Override
    public int asignarRepartidor(int idPedido, int idRepartidor) {
        String sql = """
                UPDATE pedido
                SET id_repartidor = ?,
                    estado = 'ASIGNADO'
                WHERE id_pedido = ?
                  AND estado = 'LISTO'
                  AND id_repartidor IS NULL
                """;

        return jdbcTemplate.update(sql, idRepartidor, idPedido);
    }

    @Override
    public int iniciarReparto(int idPedido, int idRepartidor) {
        String sql = """
                UPDATE pedido
                SET estado = 'EN CAMINO'
                WHERE id_pedido = ?
                  AND id_repartidor = ?
                  AND estado = 'ASIGNADO'
                """;

        return jdbcTemplate.update(sql, idPedido, idRepartidor);
    }

    @Override
    public int confirmarEntrega(int idPedido, int idRepartidor) {
        String sql = """
                UPDATE pedido
                SET estado = 'ENTREGADO',
                    fecha_entrega = COALESCE(
                        fecha_entrega,
                        CURRENT_TIMESTAMP
                    )
                WHERE id_pedido = ?
                  AND id_repartidor = ?
                  AND estado = 'EN CAMINO'
                """;

        return jdbcTemplate.update(sql, idPedido, idRepartidor);
    }
}
