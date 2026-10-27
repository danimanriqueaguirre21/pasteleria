
package org.example.repartidor;

import org.example.pedido.Pedido;

import java.util.List;

public interface RepartidorDAO {

    Pedido obtenerAsignacionBloqueada(int idPedido);

    List<Pedido> listarPedidosPorRepartidor(int idRepartidor);

    int iniciarReparto(int idPedido, int idRepartidor);

    int confirmarEntrega(int idPedido, int idRepartidor);
}
