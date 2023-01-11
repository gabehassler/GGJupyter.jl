module GGJupyter

using RCall

const GG_ENV = Dict{String, Any}(
    "height" => 7,
    "width" => 7
)

function gg_jupyter(plt;
                    height::Real = GG_ENV["height"],
                    width::Real = GG_ENV["width"])
    path = tempname() * ".svg"
    @rput plt
    @rput path
    @rput height
    @rput width

    R"""
    ggsave(path, plot = plt, height = height, width = width)
    """
    open(path) do f
        display("image/svg+xml", read(f, String))
    end
    nothing
end

end # module GGJupyter
