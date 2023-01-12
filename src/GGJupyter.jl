module GGJupyter

export gg_jupyter

using RCall
@rlibrary ggplot2

using DataFrames

const GG_ENV = Dict{String, Any}(
    "height" => 7,
    "width" => 7
)

function gg_jupyter(;kw_args...)
    gg_jupyter(last_plot(); kw_args...)
end

function gg_jupyter(plt;
                    height::Real = GG_ENV["height"],
                    width::Real = GG_ENV["width"])

    path = tempname() * ".svg"
    ggsave(path, plot = plt, height = height, width = width)
    open(path) do f
        display("image/svg+xml", read(f, String))
    end
    nothing
end

end # module GGJupyter
