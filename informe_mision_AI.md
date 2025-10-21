# Informe de Misión — Asistente de Desarrollo AI

## Visión general del proyecto

Objetivo: Construir una aplicación de gestión de tareas (TODO) en Flutter para enseñar gestión de estado usando el patrón BLoC y principios de Clean Architecture.

La estructura del proyecto se creó usando `very_good_cli` y contiene una app principal (`javerage_todos`) y paquetes locales bajo `packages/`:
- `todos_api` — Interfaces y modelos
- `local_storage_todos_api` — Implementación Flutter que usa almacenamiento local
- `todos_repository` — Repositorio para manejar peticiones relacionadas con tareas


## Tecnologías clave y patrones

- State Management: `flutter_bloc` (Blocs/Cubits para la lógica de estado a nivel de feature).
- Arquitectura: Clean Architecture con estructura feature-first; `lib/core` y `lib/features` deben ser las raíces principales.
- Monorepo: Paquetes locales dentro de `packages/` para separar responsabilidades.
- Estilo de código: Sigue las reglas y lints generados por `very_good_cli` (usar clases sealed para estados/eventos de Bloc cuando aplique).
- Dependencias importantes: `flutter_bloc`, `bloc`, `equatable`, `shared_preferences`, y los paquetes locales `todos_api` y `todos_repository`.


## Papel del Asistente IA (este archivo)

Este asistente actúa como:
- Un par programador experto que puede generar código, explicar decisiones de arquitectura y crear pruebas mínimas.
- Un tutor que da explicaciones claras con analogías didácticas.
- Un generador de boilerplate: cuando pidas código, priorizaré generar funciones concretas, widgets reutilizables y pruebas de unidad.

Modo de operación recomendado:
- Pide ejemplos específicos: "Crea un Bloc para la entidad Todo con eventos X y estados Y".
- Pide explicaciones cortas y concretas: "¿Por qué usar Cubit vs Bloc para este caso?".
- Pide que escriba pruebas (unitarias y widget) después de generar la lógica.


## Construir y ejecutar

### Prerrequisitos
- Flutter SDK instalado y en PATH
- Emulador configurado o dispositivo físico conectado
- `very_good_cli` instalado globalmente (ver `dart pub global activate very_good_cli`)

### Comandos clave
- Obtener dependencias (recursivo para paquetes locales):

```powershell
very_good packages get --recursive
```

- Ejecutar la app (modo desarrollo con un `main` específico):

```powershell
flutter run lib/main_development.dart
```

- Ejecutar tests:

```powershell
flutter test --coverage
```


## Cómo pedirme ayuda (sugerencias de prompts)

- "Genera un Bloc para gestionar la lista de todos con eventos: LoadTodos, AddTodo, UpdateTodo, DeleteTodo."
- "Crea un mock de TodosApi para tests y un test unitario para el repositorio."
- "Explica por qué usamos un repositorio entre la API y la UI en 3 frases." 


## Buenas prácticas y recordatorios

- Mantén la UI libre de lógica de negocio; todo debe pasar por Blocs/Repositiories.
- Usar paquetes locales vía `path:` en `pubspec.yaml` mientras desarrollas (o configurar melos para un workspace más robusto).
- Ejecuta linters (`very_good analyze`) antes de abrir PRs.


---

Si quieres, puedo:
- Añadir las referencias `path:` automáticamente al `pubspec.yaml` del proyecto.
- Generar un ejemplo de Bloc + pruebas para el feature de todos.
- Configurar `melos` para manejar los paquetes del monorepo.

Dime qué prefieres y lo hago.
 
## 2.2 Organizando tu Inventario: El Enfoque "Feature-First"

La arquitectura "feature-first" organiza el código por características (misiones) en lugar de por capas transversales. Esto facilita el desarrollo en equipo y reduce el acoplamiento entre funcionalidades.

Estructura recomendada dentro de `lib/`:

- `lib/core/`
	- `app.dart` (punto de entrada de la app)
	- `bootstrap.dart` (configuración inicial, inyección de dependencias)
	- `theme/`, `utils/`, `exceptions/`, `widgets/` compartidos

- `lib/features/`
	- `home/`
		- `presentation/` (widgets, pages)
		- `application/` (blocs/cubits, use cases)
		- `domain/` (models, repositories interfaces)
		- `data/` (implementaciones, datasources)
	- `todos_overview/` (misma estructura que arriba)
	- `edit_todo/`
	- `stats/`

Consejos prácticos:
- Mueve `app.dart` y `bootstrap.dart` a `lib/core/` para que estén disponibles globalmente.
- Cada feature debería poder ser movida o extraída fácilmente a un paquete independiente.
- Mantén la UI (presentation) libre de lógica de negocios; la lógica debe vivir en `application` (Blocs/Cubits) y `domain`.
- Cuando crees tests, colócalos en una estructura paralela: `test/features/<feature>/`.

Ejemplo rápido (árbol de carpetas):

```
lib/
├─ core/
│  ├─ app.dart
│  ├─ bootstrap.dart
│  ├─ theme/
│  └─ utils/
└─ features/
	 ├─ todos_overview/
	 │  ├─ presentation/
	 │  ├─ application/
	 │  ├─ domain/
	 │  └─ data/
	 └─ edit_todo/
			├─ presentation/
			├─ application/
			├─ domain/
			└─ data/
```

Si quieres, puedo:
- Mover `app.dart` y `bootstrap.dart` a `lib/core/` automáticamente.
- Generar plantillas iniciales (Blocs, pages, modelos) para `todos_overview` y `edit_todo`.
