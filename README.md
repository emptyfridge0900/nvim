### "
last yank/delete
### "0p 
Paste from register 0
### "aY
Yanks a line into the a register
### ciw 
cut inner word
### ci" 
cut inner ""
### ci< 
cut inner <>
### di" 
delete inner ""
### da" 
delete "" and inner ""
### ysiw"
### ysi("
### cs[( 
change surrounding [ to (
### * 
goes to the next matching word
### \# 
goes to the previous matching word
### ;
reapeat the command
### f{char} F{char}
다음 나타나는 char로 가기
> f(;  
> cfo  
> df(  
> d2f(  
### t{char} T{char}
다음 나타나는 char 앞으로 가기
> cto
> dt(

### q{char}
{char}에 리코딩 시작
### q
리코딩 종료
### @{char}
리코딩 했던 명령 재실행

### m{char}
{char}에 마크 하기

### "{char}
{char}에 버퍼저장

q-리코딩  
m-마크  
"-레지스터  

### zz
현재 라인을 에디터의 중간에 두기
### zt
현재 라인을 에디터의 top에 두기
### zb
현재 라인을 에디터의 bottom 에 두기
### ctrl+e
한줄 스크롤해 내리기
### ctrl+y
한줄 스크롤해 올리기
### ctrl+d
반페이지 스크롤해 내리기
### ctrl+u
반페이지 스크롤해 올리기
### ctrl+f
한페이지 스크롤해 내리기
### ctrl+b
한페이지 스크롤해 올리기



### ctrl+t
tag stack
### ctrl+o
jump list

netrw
:Ex
netrw에서 %는 파일생성
netrw에서 d는 폴더생성

runtime path
:h rtp

v로 블록 지정하고 = 누르면 포맷해줌
https://superuser.com/questions/782391/vim-enclose-in-quotes
https://stackoverflow.com/questions/41758217/whats-the-difference-between-command-cw-and-ciw-in-vim
https://github.com/tpope/vim-surround
https://vim.fandom.com/wiki/Using_marks 
https://vim.fandom.com/wiki/Jumping_to_previously_visited_locations
