include("funcs.jl")

seen_configs = Dict()
done = false
game = initialize_board()
el = (0,0)
@time play(game,game)

from_ind = []
to_ind = []
for el in keys(seen_configs)
    (fr,to) = seen_configs[el]
    push!(from_ind, fr)
    push!(to_ind, to)
end

winning_sequence = [el]

while el[1] != 0
    ind = findall(x -> x == el[2], from_ind)[1]
    el = (from_ind[ind], to_ind[ind])
    push!(winning_sequence, el)
end

winning_configs = []
for el in winning_sequence
    for key in keys(seen_configs)
        if seen_configs[key] == el
            push!(winning_configs, key)
        end
    end
end

final_sq = get_winning_moves(winning_configs)


##visualization

# for i = 1:length(winning_configs)-1
#     tmp = winning_configs[i+1]-winning_configs[i]
#     display(tmp)
# end
