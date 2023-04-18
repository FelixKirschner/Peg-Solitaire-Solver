function initialize_board()
    init = zeros(Int8, 7,7)

    outside_indices = [1,2,6,7]

    for i in outside_indices
        for j in outside_indices
            init[i,j] -= 1
        end
    end

    init[4,4] = 1

    return init

end

#this function gathers all possible (backwards) moves, i.e. when both consecutive orthogonal cells are empty.
function get_adj(board, i , j )
    arr = []
    if i-2 >= 1 && (board[i-1,j],board[i-2,j]) == (0,0)
        push!(arr, (i-2,j))
    end
    if i+2 <= 7 && (board[i+1,j],board[i+2,j]) == (0,0)
        push!(arr, (i+2,j))
    end
    if j-2 >= 1 && (board[i,j-1],board[i,j-2]) == (0,0)
        push!(arr, (i,j-2))
    end
    if j+2 <=7 && (board[i,j+1],board[i,j+2]) == (0,0)
        push!(arr, (i,j+2))
    end
    return arr
end

#get possible move, i.e., for all balls in tiles gather get_adj
function possible_moves(game)
    poss_moves = []
    for i = 1:7
        for j = 1:7
            if game[i , j] == 1
                surrounding = get_adj(game, i,j)
                for el in surrounding
                    push!(poss_moves, ((i,j),el))
                end
            end
        end
    end
    return poss_moves
end

#get rotations of board to factor out symmetries , reflections missing
function get_rotations(board)

    arr = []
    push!(arr, board)
    tmp_mat = zeros(Int8, 7,7)
    tmp_mat2 = zeros(Int8, 7,7)
    tmp_mat3 = zeros(Int8, 7,7)

    for i = 1:7
        for j = 1:7
            tmp_mat[8-j,i] = board[i,j]
        end
    end 
    push!(arr, tmp_mat)

    for i = 1:7
        for j = 1:7
            tmp_mat2[j,8-i] = board[i,j]
        end
    end

    push!(arr,tmp_mat2)

    for i = 1:7
        for j = 1:7
            tmp_mat3[8-i,8-j] = board[i,j]
        end
    end

    push!(arr, tmp_mat3)

    return arr
end

#check if currect board already exists in board_momery
function check_existence(board)
    rotations = get_rotations(board)

    for rot in rotations
        if in(rot, board_memory)
            return true
        end
    end
    return false
end


function perform_move(board, move)

    #check legality
    reference_board = deepcopy(board)
    put_in = (Integer((move[1][1]+move[2][1])/2),Integer((move[1][2]+move[2][2])/2))

    if board[move[1]...] != 1 || board[move[2]...] != 0 || board[put_in...] != 0
        @info("Illegal move!")
    end
    
    
    reference_board[move[1]...] = 0
    reference_board[move[2]...] = 1
    reference_board[put_in...] = 1

    return reference_board

end

function play(oldboard, newboard)

    if done 
        return
    elseif haskey(seen_configs, newboard) && length(seen_configs) > 1
        return
    else
        if newboard == game
            first_index = 0
            second_index = 0
        else
            first_index = length(seen_configs)
            second_index = seen_configs[oldboard][1]
        end
        merge!(seen_configs, Dict(newboard => (first_index, second_index)))
        moves = possible_moves(newboard)
        if length(moves) == 0
            left = sum(newboard)+16
            if left == 32
                @info("Found perfect game!")
                display((first_index,second_index))
                global el = (first_index,second_index)
                global done = true
            end
            return
        else
            for el in moves
                play(newboard, perform_move(newboard, el))
            end
        end
    end
end

function is_okay(cart_ind)
    if cart_ind[1] < 1 || cart_ind[1] > 7 || cart_ind[2] < 1 || cart_ind[2] > 7
        return false
    else
        return true
    end
end

function get_winning_moves(winning_configs)

    winning_moves = []
    dirs = [CartesianIndex(2,0), CartesianIndex(0,2), CartesianIndex(-2,0), CartesianIndex(0,-2)]
    for i = 1:length(winning_configs)-1
        tmp = winning_configs[i+1]-winning_configs[i]
        to = findall(x -> x == 1, tmp)[1]
        for el in dirs
            new = to+el
            if is_okay(new)
                if tmp[new] == -1
                    push!(winning_moves, ((new[1], new[2]), (to[1],to[2])))
                end
            end
        end 
    end
    return winning_moves
end


