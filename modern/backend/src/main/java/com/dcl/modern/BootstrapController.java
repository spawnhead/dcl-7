package com.dcl.modern;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/bootstrap")
class BootstrapController {

  @GetMapping("/status")
  Map<String, String> status() {
    // Traceability: bootstrap endpoint for initial readiness checks per docs/DEVELOPMENT_HANDOFF.md.
    return Map.of("service", "dcl-modern-backend", "status", "ok");
  }
}
