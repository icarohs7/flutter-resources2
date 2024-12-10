import os

command = '&&'.join([
    'flutter packages get',
    'flutter analyze',
    'flutter test --coverage'
])

return_code = os.system(command)
if return_code != 0:
    print(f'Module failed with return code: {return_code}')
    raise RuntimeError()

print(f'Module succeeded building')
