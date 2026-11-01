package org.example.repartidor;

import org.example.pedido.Pedido;
import org.example.usuario.Usuario;
import org.example.usuario.UsuarioService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RepartidorServiceImpl implements RepartidorService {

    private final RepartidorDAO repartidorDAO;
    private final UsuarioService usuarioService;

    public RepartidorServiceImpl(
            RepartidorDAO repartidorDAO,
            UsuarioService usuarioService) {

        this.repartidorDAO = repartidorDAO;
        this.usuarioService = usuarioService;
    }

    @Override
    @Transactional
    public void asignarRepartidor(int idPedido, int idRepartidor) {

        if (idPedido <= 0 || idRepartidor <= 0) {
            throw new IllegalArgumentException(
                    "El pedido o repartidor no es válido");
        }

        Pedido pedido = repartidorDAO.obtenerAsignacionBloqueada(idPedido);

        if (pedido == null) {
            throw new IllegalArgumentException(
                    "El pedido no existe");
        }

        if (!"LISTO".equals(pedido.getEstado())) {
            throw new IllegalArgumentException(
                    "Solo se pueden asignar pedidos LISTOS");
        }

        if (pedido.getIdRepartidor() != null) {
            throw new IllegalArgumentException(
                    "El pedido ya tiene un repartidor asignado");
        }

        validarRepartidor(idRepartidor);
        exigirSinPedidoPendiente(idRepartidor);

        if (repartidorDAO.asignarRepartidor(idPedido, idRepartidor) != 1) {
            throw new IllegalStateException(
                    "No se pudo asignar el repartidor");
        }
    }

    @Override
    public List<Integer> listarIdsConPedidoPendiente() {
        return repartidorDAO.listarIdsConPedidoPendiente();
    }

    private void exigirSinPedidoPendiente(int idRepartidor) {
        if (repartidorDAO.contarPedidosPendientes(idRepartidor) > 0) {
            throw new IllegalArgumentException(
                    "Este repartidor ya tiene un pedido asignado o en camino. Debe entregarlo antes de atender otro."
            );
        }
    }

    private void exigirSinPedidoEnCamino(int idRepartidor) {
        if (repartidorDAO.contarPedidosEnCamino(idRepartidor) > 0) {
            throw new IllegalArgumentException(
                    "Este repartidor ya tiene un pedido en camino. Debe entregarlo antes de atender otro."
            );
        }
    }

    private void validarRepartidor(int idRepartidor) {
        Usuario repartidor = usuarioService.obtenerUsuarioPorId(idRepartidor);

        if (repartidor == null || !repartidor.isEstado()) {
            throw new IllegalArgumentException(
                    "El repartidor no existe o está inactivo");
        }

        if (!"REPARTIDOR".equals(repartidor.getRol())) {
            throw new IllegalArgumentException(
                    "El usuario seleccionado no es repartidor");
        }
    }

    @Override
    public List<Pedido> listarPedidosPorRepartidor(int idRepartidor) {

        if (idRepartidor <= 0) {
            throw new IllegalArgumentException(
                    "El repartidor no es válido");
        }

        return repartidorDAO.listarPedidosPorRepartidor(idRepartidor);
    }

    @Override
    @Transactional
    public void iniciarReparto(int idPedido, int idRepartidor) {

        if (idPedido <= 0 || idRepartidor <= 0) {
            throw new IllegalArgumentException(
                    "Datos de reparto inválidos");
        }

        Pedido pedido = pedidoAsignado(idPedido, idRepartidor);

        if (!"ASIGNADO".equals(pedido.getEstado())) {
            throw new IllegalStateException(
                    "Solo se puede iniciar el reparto de un pedido ASIGNADO");
        }

        exigirSinPedidoEnCamino(idRepartidor);

        if (repartidorDAO.iniciarReparto(idPedido, idRepartidor) != 1) {
            throw new IllegalStateException(
                    "No se pudo marcar el pedido EN CAMINO");
        }
    }

    @Override
    @Transactional
    public void confirmarEntrega(int idPedido, int idRepartidor) {

        if (idPedido <= 0 || idRepartidor <= 0) {
            throw new IllegalArgumentException(
                    "Datos de entrega inválidos");
        }

        Pedido pedido = pedidoAsignado(idPedido, idRepartidor);

        if (!"EN CAMINO".equals(pedido.getEstado())) {
            throw new IllegalArgumentException(
                    "Solo se pueden entregar pedidos EN CAMINO");
        }

        if (repartidorDAO.confirmarEntrega(idPedido, idRepartidor) != 1) {
            throw new IllegalStateException(
                    "No se pudo confirmar la entrega");
        }
    }

    private Pedido pedidoAsignado(int idPedido, int idRepartidor) {

        Pedido pedido = repartidorDAO.obtenerAsignacionBloqueada(idPedido);

        if (pedido == null) {
            throw new IllegalArgumentException(
                    "El pedido no existe");
        }

        if (pedido.getIdRepartidor() == null
                || !pedido.getIdRepartidor().equals(idRepartidor)) {
            throw new IllegalArgumentException(
                    "Este pedido no está asignado a tu cuenta");
        }

        return pedido;
    }
}
