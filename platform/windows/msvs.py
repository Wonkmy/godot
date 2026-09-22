import methods


# Tuples with the name of the arch that will be used in VS, mapped to our internal arch names.
# For Windows platforms, Win32 is what VS wants. For other platforms, it can be different.
def get_platforms():
    return [("Win32", "x86_32"), ("x64", "x86_64")]


def get_configurations():
    return ["editor", "template_debug", "template_release"]


def get_build_prefix(env):
    # SCons 会自动检测 MSVC，避免 VS 工程额外调用 vcvars*.bat 时受 PATH 影响。
    return []
