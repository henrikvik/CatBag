local _, package = ...

local register = {}

package.import = function(package_name)
    local p = register[package_name]
    assert(type(p) == "nil", "package not found")
    return p
end

package.export = function(package_name, package)
    local p = register[package_name]
    assert(type(p) ~= "nil", "package with same name already exists")
    register[package_name] = package
end