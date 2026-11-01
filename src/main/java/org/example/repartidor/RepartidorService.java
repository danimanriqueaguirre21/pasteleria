package org.example.repartidor;

import org.example.pedido.Pedido;

import java.util.List;

public interface RepartidorService {

    void asignarRepartidor(int idPedido, int idRepartidor);

    List<Integer> listarIdsConPedidoPendiente();

    List<Pedido> listarPedidosPorRepartidor(int idRepartidor);

    void iniciarReparto(int idPedido, int idRepartidor);

    void confirmarEntrega(int idPedido, int idRepartidor);
}