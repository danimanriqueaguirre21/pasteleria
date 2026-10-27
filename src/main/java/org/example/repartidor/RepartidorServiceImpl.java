
package org.example.repartidor;

import org.example.pedido.Pedido;
import org.example.pedido.PedidoDAO;
import org.example.usuario.Usuario;
import org.example.usuario.UsuarioDAO;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RepartidorServiceImpl implements RepartidorService {

    private final PedidoDAO pedidoDAO;
    private final RepartidorDAO repartidorDAO;
    private final UsuarioDAO usuarioDAO;

    public RepartidorServiceImpl(
            PedidoDAO pedidoDAO,
            RepartidorDAO repartidorDAO,
            UsuarioDAO usuarioDAO) {

        this.pedidoDAO = pedidoDAO;
        this.repartidorDAO = repartidorDAO;
        this.usuarioDAO = usuarioDAO;
    }

    @Override
    @Transactional
    public void asignarRepartidor(
            int idPedido,
            int idRepartidor) {

        if (idPedido <= 0 || idRepartidor <= 0) {
            throw new IllegalArgumentException(
                    "El pedido o repartidor no es válido");
        }

        Pedido pedido =
                repartidorDAO.obtenerAsignacionBloqueada(idPedido);

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

        Usuario repartidor =
                usuarioDAO.obtenerUsuarioPorId(idRepartidor);

        if (repartidor == null || !repartidor.isEstado()) {
            throw new IllegalArgumentException(
                    "El repartidor no existe o está inactivo");
        }

        int idRolRepartidor =
                usuarioDAO.obtenerIdRolPorNombre("REPARTIDOR");

        if (repartidor.getIdRol() == null
                || !repartidor.getIdRol().equals(idRolRepartidor)) {
            throw new IllegalArgumentException(
                    "El usuario seleccionado no es repartidor");
        }

        int filasActualizadas =
                pedidoDAO.asignarRepartidor(
                        idPedido,
                        idRepartidor);

        if (filasActualizadas != 1) {
            throw new IllegalStateException(
                    "No se pudo asignar el repartidor");
        }
    }

    @Override
    public List<Pedido> listarPedidosPorRepartidor(
            int idRepartidor) {

        if (idRepartidor <= 0) {
            throw new IllegalArgumentException(
                    "El repartidor no es válido");
        }

        return repartidorDAO.listarPedidosPorRepartidor(
                idRepartidor);
    }

    @Override
    @Transactional
    public void iniciarReparto(
            int idPedido,
            int idRepartidor) {

        if (idPedido <= 0 || idRepartidor <= 0) {
            throw new IllegalArgumentException(
                    "Datos de reparto inválidos");
        }

        Pedido pedido =
                repartidorDAO.obtenerAsignacionBloqueada(idPedido);

        if (pedido == null) {
            throw new IllegalArgumentException(
                    "El pedido no existe");
        }

        if (pedido.getIdRepartidor() == null
                || !pedido.getIdRepartidor().equals(idRepartidor)) {
            throw new IllegalArgumentException(
                    "Este pedido no está asignado a tu cuenta");
        }

        if (!"ASIGNADO".equals(pedido.getEstado())) {
            throw new IllegalStateException(
                    "Solo se puede iniciar el reparto de un pedido ASIGNADO");
        }

        int filasActualizadas =
                repartidorDAO.iniciarReparto(
                        idPedido,
                        idRepartidor);

        if (filasActualizadas != 1) {
            throw new IllegalStateException(
                    "No se pudo marcar el pedido EN CAMINO");
        }
    }

    @Override
    @Transactional
    public void confirmarEntrega(
            int idPedido,
            int idRepartidor) {

        if (idPedido <= 0 || idRepartidor <= 0) {
            throw new IllegalArgumentException(
                    "Datos de entrega inválidos");
        }

        Pedido pedido =
                repartidorDAO.obtenerAsignacionBloqueada(idPedido);

        if (pedido == null) {
            throw new IllegalArgumentException(
                    "El pedido no existe");
        }

        if (pedido.getIdRepartidor() == null
                || !pedido.getIdRepartidor().equals(idRepartidor)) {
            throw new IllegalArgumentException(
                    "Este pedido no está asignado a tu cuenta");
        }

        if (!"EN CAMINO".equals(pedido.getEstado())) {
            throw new IllegalArgumentException(
                    "Solo se pueden entregar pedidos EN CAMINO");
        }

        int filasActualizadas =
                repartidorDAO.confirmarEntrega(
                        idPedido,
                        idRepartidor);

        if (filasActualizadas != 1) {
            throw new IllegalStateException(
                    "No se pudo confirmar la entrega");
        }
    }
}
