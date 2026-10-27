
package org.example.repartidor;

import org.example.pedido.Pedido;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RepartidorRepository implements RepartidorDAO {

    private final JdbcTemplate jdbcTemplate;

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
                SELECT *
                FROM pedido
                WHERE id_repartidor = ?
                  AND estado IN ('ASIGNADO', 'EN CAMINO', 'ENTREGADO')
                ORDER BY fecha_pedido DESC, id_pedido DESC
                """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Pedido pedido = new Pedido();
            pedido.setIdPedido(rs.getInt("id_pedido"));
            pedido.setEstado(rs.getString("estado"));

            int idRepartidorPedido = rs.getInt("id_repartidor");
            pedido.setIdRepartidor(
                    rs.wasNull() ? null : idRepartidorPedido
            );

            return pedido;
        }, idRepartidor);
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
