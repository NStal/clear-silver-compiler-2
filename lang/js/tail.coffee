start = Date.now()
count = 10 *1000
for _ in [0..count]
    outputBuffers.length = 0
    main()
    HDF.call(Dataset,json)
    outputBuffers.join("")

end = Date.now()
console.log end - start,"ms"
console.log count,"task ,",(end - start)/count,"per task"
console.log "result",outputBuffers.join("")