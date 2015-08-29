
rm -rf main

make

filePath = './main'

if [ -f $filePath]; then
    for (( ; ;))
    do
        ./main
    done
fi

