module GGJupyter

export gg_jupyter,
       quick_hist,
       quick_scatter

using RCall

function setup_R()
    R"""
    library(ggplot2)
    themes <- list(
        default = theme_minimal() +
            theme(plot.title = element_text(hjust = 0.5))
    )
    """
end

using DataFrames

const GG_ENV = Dict{String, Any}(
    "height" => 7,
    "width" => 7
)

function gg_jupyter(;kw_args...)
    gg_jupyter(""; kw_args...)
end



function gg_jupyter(plt;
                    height::Real = GG_ENV["height"],
                    width::Real = GG_ENV["width"])

    @rput plt
    @rput height
    @rput width

    path = tempname() * ".svg"
    @rput path
    R"""
    if (plt == "") {
        plt = last_plot()
    }
    ggsave(path, plot = plt, height = height, width = width)
    """
    open(path) do f
        display("image/svg+xml", read(f, String))
    end
    nothing
end

function quick_hist(df::DataFrame, xvar::String;
                    title::String = "",
                    theme::String = "default")
    @rput df
    @rput xvar
    @rput title
    this_theme = theme
    @rput this_theme
    R"""
    ggplot(df, aes(x = .data[[xvar]])) +
        geom_histogram(bins = 30) +
        ggtitle(title) +
        xlab(xvar) +
        themes[this_theme]
    """
    gg_jupyter()
end

function quick_scatter(df::DataFrame; x::String, y::String,
                       title::String = "",
                       theme::String = "default",
                       alpha::Real = 1)

    @rput df
    @rput x
    @rput y
    @rput title
    @rput alpha
    this_theme = theme
    @rput this_theme
    R"""
    ggplot(df, aes(x = .data[[x]], y = .data[[y]])) +
        geom_point(alpha = alpha) +
        ggtitle(title) +
        themes[this_theme]
    """
    gg_jupyter()
end

end # module GGJupyter
