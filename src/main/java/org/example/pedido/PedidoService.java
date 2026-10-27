
package org.example.pedido;

import org.example.carrito.ItemCarrito;

import java.util.List;
import java.util.Map;

public interface PedidoService {

    int confirmarPedido(
            int idUsuario,
            String direccionEntrega,
            String telefono,
            String medioPago,
            List<ItemCarrito> carrito
    );

    Pedido obtenerPedidoPorId(int idPedido);

    List<Pedido> listarPedidosPorUsuario(int idUsuario);

    List<DetallePedido> listarDetallesPorPedido(int idPedido);

    List<DetallePedido> listarTodosLosDetalles();

    List<Pedido> listarTodosLosPedidos();

    void actualizarEstadoPedido(
            int idPedido,
            String nuevoEstado
    );

    void cancelarPedido(
            int idPedido,
            int idUsuario
    );

    Pedido obtenerPedidoPorCodigoSeguimiento(
            String codigoSeguimiento
    );

    int registrarVentaEnTienda(
            String telefono,
            String medioPago,
            List<Integer> idProductos,
            List<Integer> cantidades
    );

    List<Integer> leerCantidades(List<String> cantidad);

    Map<String, List<Pedido>> agruparPorEstado(List<Pedido> pedidos);

    Map<Integer, String> nombresDeClientes(List<Pedido> pedidos);

    Map<Integer, String> resumirProductos();

    Map<String, Long> contarPorEstado(List<Pedido> pedidos);

}
