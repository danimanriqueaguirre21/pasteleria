
package org.example.repartidor;

import org.example.pedido.Pedido;

import java.util.List;

public interface RepartidorDAO {

    Pedido obtenerAsignacionBloqueada(int idPedido);

    List<Pedido> listarPedidosPorRepartidor(int idRepartidor);

    int contarPedidosPendientes(int idRepartidor);

    List<Integer> listarIdsConPedidoPendiente();

    int contarPedidosEnCamino(int idRepartidor);

    int asignarRepartidor(int idPedido, int idRepartidor);

    int iniciarReparto(int idPedido, int idRepartidor);

    int confirmarEntrega(int idPedido, int idRepartidor);
}
