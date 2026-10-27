
package org.example.pedido;

import java.util.List;

public interface PedidoDAO {

    int registrarPedido(Pedido pedido);

    void registrarDetalle(DetallePedido detalle);

    Pedido obtenerPedidoPorId(int idPedido);

    List<Pedido> listarPedidosPorUsuario(int idUsuario);

    List<DetallePedido> listarDetallesPorPedido(int idPedido);

    List<DetallePedido> listarTodosLosDetalles();

    List<Pedido> listarTodosLosPedidos();

    int actualizarEstadoPedido(int idPedido, String estadoActual, String nuevoEstado);

    String obtenerEstadoBloqueado(int idPedido);

    int asignarRepartidor(int idPedido, int idRepartidor);

    Pedido obtenerPedidoPorCodigoSeguimiento(String codigoSeguimiento);

    Pedido obtenerDatosCancelacionBloqueado(int idPedido);

    int cancelarPedido(int idPedido, int idUsuario);

    void registrarFechaEntrega(int idPedido);
}
