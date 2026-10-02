import { api, tieneCsrf, yo } from "../login/login.js";

const modal = document.getElementById("modalNuevoUsuario");
const form = modal.querySelector("form");
const btnGuardar = modal.querySelector(".modal-footer .btn-primary");
const tbody = document.querySelector("#pane-usuarios tbody");
const selectTipo = document.getElementById("usuario-tipo");
const selectEmpleado = document.getElementById("usuario-empleado");
const contenedorRoles = document.getElementById("usuario-roles");

const alerta = document.createElement("div");
alerta.className = "alert alert-danger d-none";
form.prepend(alerta);

function leer(obj, claves) {
  if (!obj) {
    return undefined;
  }
  const clave = claves.find((c) => obj[c] !== undefined && obj[c] !== null);
  return clave === undefined ? undefined : obj[clave];
}

// Acepta texto o un objeto anidado ({ nRol: "..." }).
function aTexto(valor) {
  if (valor && typeof valor === "object") {
    return Object.values(valor).find((v) => typeof v === "string") || "";
  }
  return valor === undefined || valor === null ? "" : String(valor);
}

function mostrarError(mensaje) {
  alerta.textContent = mensaje;
  alerta.classList.remove("d-none");
}

function limpiarError() {
  alerta.textContent = "";
  alerta.classList.add("d-none");
}

function irALogin(err) {
  if (err.status === 401) {
    window.location.href = "../login/login.html";
    return true;
  }
  return false;
}

function nombreEmpleado(e) {
  const persona = e.persona || e;
  return (
    leer(e, ["nombreCompleto"]) ||
    [
      leer(persona, ["nombre"]),
      leer(persona, ["apPaterno"]),
      leer(persona, ["apMaterno"]),
    ]
      .filter(Boolean)
      .join(" ")
  );
}

/* ---------- Listado ---------- */

function celda(texto) {
  const td = document.createElement("td");
  td.textContent = texto;
  return td;
}

function badge(texto, clase) {
  const span = document.createElement("span");
  span.className = "badge " + clase;
  span.textContent = texto;
  return span;
}

function filaUsuario(u, indice) {
  const tr = document.createElement("tr");
  tr.appendChild(celda(leer(u, ["idUsuario", "id"]) ?? indice + 1));
  tr.appendChild(celda(aTexto(leer(u, ["logeo"]))));

  const empleado = leer(u, ["empleado"]);
  tr.appendChild(
    celda(
      leer(u, ["nombreEmpleado"]) ||
        (empleado && typeof empleado === "object"
          ? nombreEmpleado(empleado)
          : aTexto(empleado)),
    ),
  );

  const tdRoles = document.createElement("td");
  (leer(u, ["roles"]) || []).forEach((rol) => {
    tdRoles.appendChild(badge(aTexto(rol), "text-bg-info me-1"));
  });
  tr.appendChild(tdRoles);

  const tdEstado = document.createElement("td");
  const estado = leer(u, ["estado"]);
  const activo = estado !== "0" && estado !== false;
  tdEstado.appendChild(
    badge(
      activo ? "Activo" : "Inactivo",
      activo ? "text-bg-success" : "text-bg-secondary",
    ),
  );
  tr.appendChild(tdEstado);

  const fecha = leer(u, ["fecCre"]);
  tr.appendChild(
    celda(fecha ? new Date(fecha).toLocaleDateString("es-PE") : ""),
  );

  const tdAcciones = document.createElement("td");
  tdAcciones.innerHTML =
    '<div class="d-flex gap-1">' +
    '<button class="btn btn-sm btn-outline-primary" title="Editar"><i class="bi bi-pencil"></i></button>' +
    (activo
      ? '<button class="btn btn-sm btn-outline-primary" title="Desactivar"><i class="bi bi-toggle-on"></i></button>'
      : '<button class="btn btn-sm btn-outline-secondary" title="Activar"><i class="bi bi-toggle-off opacity-50"></i></button>') +
    "</div>";
  tr.appendChild(tdAcciones);
  return tr;
}

function filaMensaje(texto) {
  const tr = document.createElement("tr");
  const td = celda(texto);
  td.colSpan = 7;
  td.className = "text-center text-muted";
  tr.appendChild(td);
  return tr;
}

let usuarios = [];

async function listarUsuarios() {
  try {
    usuarios = (await api("GET", "/api/usuarios")) || [];
    if (!usuarios.length) {
      tbody.replaceChildren(filaMensaje("No hay usuarios registrados."));
      return;
    }
    tbody.replaceChildren(...usuarios.map(filaUsuario));
  } catch (err) {
    if (!irALogin(err)) {
      tbody.replaceChildren(filaMensaje(err.mensaje || "No se pudo cargar."));
    }
  }
}

/* ---------- Catálogos del modal ---------- */

function llenarSelect(select, items, claveId, textoDe) {
  const placeholder = select.querySelector('option[value=""]');
  select.replaceChildren(placeholder);
  items.forEach((item) => {
    const opcion = document.createElement("option");
    opcion.value = leer(item, claveId);
    opcion.textContent = textoDe(item);
    select.appendChild(opcion);
  });
}

function llenarRoles(roles) {
  contenedorRoles.replaceChildren(
    ...roles.map((rol) => {
      const id = leer(rol, ["idRol", "id"]);
      const div = document.createElement("div");
      div.className = "form-check form-switch";

      const input = document.createElement("input");
      input.className = "form-check-input";
      input.type = "checkbox";
      input.role = "switch";
      input.id = "usuario-rol-" + id;
      input.value = id;

      const label = document.createElement("label");
      label.className = "form-check-label";
      label.htmlFor = input.id;
      label.textContent = aTexto(leer(rol, ["nRol", "nombre"]));

      div.append(input, label);
      return div;
    }),
  );
}

// Solo se ofrecen empleados que todavía no tienen usuario.
function idsEmpleadosConUsuario() {
  return new Set(
    usuarios
      .map((u) => leer(u, ["idEmpleado"]) ?? leer(u.empleado, ["idEmpleado"]))
      .filter((id) => id !== undefined),
  );
}

async function cargarCatalogos() {
  try {
    const [tipos, roles, empleados] = await Promise.all([
      api("GET", "/api/usuarios/tipos"),
      api("GET", "/api/usuarios/roles"),
      api("GET", "/api/empleados"),
    ]);
    llenarSelect(selectTipo, tipos || [], ["idTipoUsuario", "id"], (t) =>
      aTexto(leer(t, ["nTipoUsuario", "nombre"])),
    );
    llenarRoles(roles || []);
    const ocupados = idsEmpleadosConUsuario();
    llenarSelect(
      selectEmpleado,
      (empleados || []).filter(
        (e) => !ocupados.has(leer(e, ["idEmpleado", "id"])),
      ),
      ["idEmpleado", "id"],
      nombreEmpleado,
    );
    return true;
  } catch (err) {
    if (!irALogin(err)) {
      mostrarError(err.mensaje || "No se pudieron cargar los catálogos.");
    }
    return false;
  }
}

/* ---------- Alta ---------- */

function armarPayload() {
  const empleado = selectEmpleado.value;
  return {
    idTipoUsuario: Number(selectTipo.value),
    idEmpleado: empleado === "" ? null : Number(empleado),
    logeo: document.getElementById("usuario-logeo").value.trim(),
    clave: document.getElementById("usuario-clave").value,
    idsRol: Array.from(
      contenedorRoles.querySelectorAll("input:checked"),
      (input) => Number(input.value),
    ),
  };
}

function validar(payload, clave2) {
  const errores = [];
  if (!payload.logeo) {
    errores.push("El usuario es obligatorio.");
  }
  if (!selectTipo.value) {
    errores.push("El tipo de usuario es obligatorio.");
  }
  if (payload.clave.length < 8 || payload.clave.length > 100) {
    errores.push("La contraseña debe tener entre 8 y 100 caracteres.");
  } else if (payload.clave !== clave2) {
    errores.push("Las contraseñas no coinciden.");
  }
  return errores;
}

async function guardarUsuario() {
  limpiarError();
  const payload = armarPayload();
  const clave2 = document.getElementById("usuario-clave2").value;
  const errores = validar(payload, clave2);
  if (errores.length) {
    mostrarError(errores.join(" "));
    return;
  }

  btnGuardar.disabled = true;
  try {
    if (!tieneCsrf()) {
      await yo();
    }
    await api("POST", "/api/usuarios", payload);
    form.reset();
    bootstrap.Modal.getInstance(modal).hide();
    await listarUsuarios();
  } catch (err) {
    if (!irALogin(err)) {
      mostrarError(err.mensaje || "No se pudo guardar el usuario.");
    }
  } finally {
    btnGuardar.disabled = false;
  }
}

modal.addEventListener("show.bs.modal", () => {
  limpiarError();
  cargarCatalogos();
});
btnGuardar.addEventListener("click", guardarUsuario);

listarUsuarios();
