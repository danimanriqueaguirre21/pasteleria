
package org.example.estadistica;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class EstadisticaController {

    private final EstadisticaService estadisticaService;

    public EstadisticaController(
            EstadisticaService estadisticaService) {

        this.estadisticaService = estadisticaService;
    }

    @GetMapping("/admin/estadisticas")
    public String mostrarEstadisticas(Model model) {

        model.addAttribute("ventasDiarias", estadisticaService.obtenerVentasDiarias());
        model.addAttribute("pedidosPorDia", estadisticaService.obtenerPedidosPorDia());
        model.addAttribute("entregasPorDia", estadisticaService.obtenerEntregasPorDia());
        model.addAttribute("ticketPromedioPorDia", estadisticaService.obtenerTicketPromedioPorDia());
        model.addAttribute("unidadesVendidasPorDia", estadisticaService.obtenerUnidadesVendidasPorDia());
        model.addAttribute("importeTotal", estadisticaService.obtenerImporteTotal());
        model.addAttribute("totalPedidos", estadisticaService.obtenerTotalPedidos());
        model.addAttribute("totalEntregados", estadisticaService.obtenerTotalEntregados());
        model.addAttribute("ticketPromedioGeneral", estadisticaService.obtenerTicketPromedioGeneral());
        model.addAttribute("totalUnidades", estadisticaService.obtenerTotalUnidades());

        return "admin/resumen-general";
    }
}
