
package org.example.pedido;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin/pedidos")
public class AdminPedidoController {

    private final PedidoService pedidoService;

    public AdminPedidoController(PedidoService pedidoService) {
        this.pedidoService = pedidoService;
    }

    @GetMapping
    public String listarPedidos(Model model) {
        List<Pedido> pedidos = pedidoService.listarTodosLosPedidos();

        model.addAttribute("bloques", pedidoService.agruparPorEstado(pedidos));
        model.addAttribute("nombresClientes", pedidoService.nombresDeClientes(pedidos));
        model.addAttribute("resumenProductos", pedidoService.resumirProductos());

        return "admin/pedidos-registrados";
    }
}
