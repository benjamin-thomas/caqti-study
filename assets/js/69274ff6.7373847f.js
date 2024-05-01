"use strict";(self.webpackChunkcaqti_study=self.webpackChunkcaqti_study||[]).push([[7443],{3929:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>p,contentTitle:()=>o,default:()=>d,frontMatter:()=>n,metadata:()=>l,toc:()=>c});var s=r(4848),a=r(8453);const n={},o="Hello, ppx_rapper!",l={id:"hello-ppx_rapper/README",title:"Hello, ppx_rapper!",description:"Let's take a look at ppxrapper!",source:"@site/study/hello-ppx_rapper/README.md",sourceDirName:"hello-ppx_rapper",slug:"/hello-ppx_rapper/",permalink:"/caqti-study/study/hello-ppx_rapper/",draft:!1,unlisted:!1,tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Hello, caqti-lwt!",permalink:"/caqti-study/study/hello-caqti-lwt/"},next:{title:"Hello, tests!",permalink:"/caqti-study/study/hello-tests/"}},p={},c=[{value:"Test via the REPL",id:"test-via-the-repl",level:2}];function i(e){const t={a:"a",code:"code",h1:"h1",h2:"h2",p:"p",pre:"pre",strong:"strong",...(0,a.R)(),...e.components};return(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(t.h1,{id:"hello-ppx_rapper",children:"Hello, ppx_rapper!"}),"\n",(0,s.jsxs)(t.p,{children:["Let's take a look at ",(0,s.jsx)(t.a,{href:"https://github.com/roddyyaga/ppx_rapper",children:"ppx_rapper"}),"!"]}),"\n",(0,s.jsx)(t.p,{children:"We have already seen what PPXs are, so we are good to go!"}),"\n",(0,s.jsxs)(t.p,{children:["Have a look at the ",(0,s.jsx)(t.a,{target:"_blank","data-noBrokenLinkCheck":!0,href:r(1899).A+"",children:"Exec"})," module. We converted queries from the ",(0,s.jsx)(t.a,{href:"../hello-caqti-lwt",children:"hello-caqti-lwt"})," project, to a much shorter syntax. Although, we have to adjust the SQL slightly in order to satisfy ppx_rapper's requirements."]}),"\n",(0,s.jsxs)(t.p,{children:["Also take a look ",(0,s.jsx)(t.a,{target:"_blank","data-noBrokenLinkCheck":!0,href:r(696).A+"",children:"Fake_users"})," module for other types of usage, and as always the tests."]}),"\n",(0,s.jsx)(t.p,{children:(0,s.jsx)(t.strong,{children:"NOTE"})}),"\n",(0,s.jsx)(t.p,{children:"At the time of writing, it's necessary to run this command in order to have a version of ppx_rapper compatible with the latest Caqti version."}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{children:"opam pin add git+https://github.com/roddyyaga/ppx_rapper#2222edbbe68db7ba1ab0c7a2688c227ea5c0f230\n"})}),"\n",(0,s.jsxs)(t.p,{children:["See ",(0,s.jsx)(t.a,{href:"https://github.com/roddyyaga/ppx_rapper/pull/35",children:"ppx_rapper PR#35"})," for more details"]}),"\n",(0,s.jsx)(t.h2,{id:"test-via-the-repl",children:"Test via the REPL"}),"\n",(0,s.jsx)(t.p,{children:"As in the previous projects, let's play with our REPL for a bit :)"}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{children:"$ PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune utop\n"})}),"\n",(0,s.jsx)(t.p,{children:"Let's initialize our connection:"}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-ocaml",children:"# open Repo;;\n# let conn = Init.connect_exn ();;\nval conn : Caqti_lwt.connection = <module>\n"})}),"\n",(0,s.jsx)(t.p,{children:"We have a new API! We use labeled arguments now, and the connection comes last. That API comes from the ppx_rapper code generation."}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-ocaml",children:"# Repo.Exec.resolve_ok_exn @@ Exec.add ~a:1 ~b:2 conn;;\n- : int = 3\n"})}),"\n",(0,s.jsx)(t.p,{children:"We can still keep our old API if it were for whatever reason necessary."}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-ocaml",children:"# Repo.Exec.resolve_ok_exn @@ Exec.mul conn 3 4 ;;\n- : int = 12\n"})}),"\n",(0,s.jsx)(t.p,{children:"We've also got a list of fake users to play with"}),"\n",(0,s.jsx)(t.pre,{children:(0,s.jsx)(t.code,{className:"language-ocaml",children:'# open Repo.Fake_users;;\n# Repo.Exec.resolve_ok_exn @@ Repo.Fake_users.fake_users () conn |> List.map (fun user -> user.email);;\n- : string list =\n["user1@example.com"; "user2@example.com"; "user3@example.com";\n "user4@example.com"; "user5@example.com"]\n'})})]})}function d(e={}){const{wrapper:t}={...(0,a.R)(),...e.components};return t?(0,s.jsx)(t,{...e,children:(0,s.jsx)(i,{...e})}):i(e)}},1899:(e,t,r)=>{r.d(t,{A:()=>s});const s=r.p+"assets/files/exec-2b7eeb4a2c98043d0c3b0d88054979d7.ml"},696:(e,t,r)=>{r.d(t,{A:()=>s});const s=r.p+"assets/files/fake_users-61c52ee656faed62178bec4526f3dbb7.ml"}}]);