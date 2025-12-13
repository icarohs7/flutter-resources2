---
apply: always
---

When generating Flutter code, prefer using flutter_hooks and HookWidget instead of StatefulWidget unless explicitly asked otherwise.
Use hooks like useState, useEffect, and useTextEditingController to handle state and lifecycles.

Do not use the command --pause-after-load when running flutter test because it
fails to run the tests