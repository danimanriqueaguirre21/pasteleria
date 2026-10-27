
package org.example.estadistica;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Map;

@Controller
public class EstadisticaController {

    private final EstadisticaService estadisticaService;

    public EstadisticaController(
            EstadisticaService estadisticaService) {

        this.estadisticaService = estadisticaService;
    }

    @GetMapping("/admin/estadisticas")
    public String mostrarEstadisticas(Model model) {

        Map<LocalDate, BigDecimal> ventasDiarias =
                estadisticaService.obtenerVentasDiarias();

        Map<LocalDate, Integer> pedidosPorDia =
                estadisticaService.obtenerPedidosPorDia();

        Map<LocalDate, Integer> entregasPorDia =
                estadisticaService.obtenerEntregasPorDia();

        Map<LocalDate, BigDecimal> ticketPromedioPorDia =
                estadisticaService.obtenerTicketPromedioPorDia();

        Map<LocalDate, Integer> unidadesVendidasPorDia =
                estadisticaService.obtenerUnidadesVendidasPorDia();

        model.addAttribute("ventasDiarias", ventasDiarias);
        model.addAttribute("pedidosPorDia", pedidosPorDia);
        model.addAttribute("entregasPorDia", entregasPorDia);

        model.addAttribute(
                "ticketPromedioPorDia",
                ticketPromedioPorDia
        );

        model.addAttribute(
                "unidadesVendidasPorDia",
                unidadesVendidasPorDia
        );

        BigDecimal importeTotal =
                estadisticaService.obtenerImporteTotal();

        int totalPedidos =
                estadisticaService.obtenerTotalPedidos();

        int totalEntregados =
                estadisticaService.obtenerTotalEntregados();

        BigDecimal ticketPromedioGeneral =
                estadisticaService.obtenerTicketPromedioGeneral();

        int totalUnidades =
                estadisticaService.obtenerTotalUnidades();

        model.addAttribute("importeTotal", importeTotal);
        model.addAttribute("totalPedidos", totalPedidos);
        model.addAttribute("totalEntregados", totalEntregados);

        model.addAttribute(
                "ticketPromedioGeneral",
                ticketPromedioGeneral
        );

        model.addAttribute("totalUnidades", totalUnidades);

        return "admin/estadisticas";
    }
}
