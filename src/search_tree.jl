
import Base.print

type Node
   left::Nullable{Node}
   right::Nullable{Node}
   value::String
end

type SearchTree
   nodes::Nullable{Node}
   function SearchTree()
     new(Nullable{Node}())
   end
end

function add!(tree::SearchTree,value::String)
   println(tree)
   println(value)
   if isnull(tree.nodes)
     tree.nodes=Node(Nullable{Node}(),Nullable{Node}(),value)
   else #find correct position in tree
      current_node=tree.nodes.value
      ready=false
      while !ready
         println(current_node)
         if value<(current_node.value)
            if isnull(current_node.left)
               current_node.left=Node(Nullable{Node}(),Nullable{Node}(),value)
               ready=true
            else
               current_node=current_node.left.value
            end
         else
            if isnull(current_node.right)
               current_node.right=Node(Nullable{Node}(),Nullable{Node}(),value)
               ready=true
            else
               current_node=current_node.right.value
            end
         end
      end
   end
end

function print(tree::SearchTree)
   println("{")
   print(tree.nodes.value,"   ")
   println("}")
end

function print(node::Node,indent::String)
   print(indent)
   println(node.value)
   if !isnull(node.left)
      println(indent*"L+ ")
      print(node.left.value,indent*" | ")
   end
   if !isnull(node.right)
      println(indent*"R+ ")
      print(node.right.value,indent*" | ")
   end
end


#testing
tree=SearchTree()
add!(tree,"hans")
add!(tree,"wim")
add!(tree,"pieter")
add!(tree,"karel")
add!(tree,"bas")
add!(tree,"jan")
add!(tree,"karel")
print(tree)
