package org.example.pedido;

import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class PedidoRowMapper implements RowMapper<Pedido> {

    @Override
    public Pedido mapRow(ResultSet rs, int rowNum) throws SQLException {

        Pedido pedido = new Pedido();

        pedido.setIdPedido(rs.getInt("id_pedido"));
        pedido.setIdUsuario(rs.getInt("id_usuario"));

        Timestamp fechaPedido = rs.getTimestamp("fecha_pedido");

        if (fechaPedido != null) {
            pedido.setFechaPedido(fechaPedido.toLocalDateTime());
        }

        Timestamp fechaEntrega = rs.getTimestamp("fecha_entrega");

        if (fechaEntrega != null) {
            pedido.setFechaEntrega(fechaEntrega.toLocalDateTime());
        }

        pedido.setDireccionEntrega(rs.getString("direccion_entrega"));
        pedido.setTelefono(rs.getString("telefono"));
        pedido.setTotal(rs.getBigDecimal("total"));
        pedido.setEstado(rs.getString("estado"));
        pedido.setMedioPago(rs.getString("medio_pago"));

        int idRepartidor = rs.getInt("id_repartidor");

        pedido.setIdRepartidor(
                rs.wasNull() ? null : idRepartidor
        );

        pedido.setCodigoSeguimiento(
                rs.getString("codigo_seguimiento")
        );

        return pedido;
    }
}
