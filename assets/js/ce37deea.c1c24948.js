"use strict";(self.webpackChunkcaqti_study=self.webpackChunkcaqti_study||[]).push([[6266],{5886:(n,t,e)=>{e.r(t),e.d(t,{assets:()=>o,contentTitle:()=>a,default:()=>h,frontMatter:()=>r,metadata:()=>d,toc:()=>l});var i=e(4848),s=e(8453);const r={sidebar_position:1,hide_table_of_contents:!0},a="Getting Started",d={id:"README",title:"Getting Started",description:"Welcome to the Caqti study!",source:"@site/study/README.md",sourceDirName:".",slug:"/",permalink:"/caqti-study/study/",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1,hide_table_of_contents:!0},sidebar:"sidebar",next:{title:"README2",permalink:"/caqti-study/study/README2"}},o={},l=[{value:"What we will be building",id:"what-we-will-be-building",level:2}];function c(n){const t={code:"code",h1:"h1",h2:"h2",li:"li",mermaid:"mermaid",p:"p",ul:"ul",...(0,s.R)(),...n.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(t.h1,{id:"getting-started",children:"Getting Started"}),"\n",(0,i.jsx)(t.p,{children:"Welcome to the Caqti study!"}),"\n",(0,i.jsx)(t.h2,{id:"what-we-will-be-building",children:"What we will be building"}),"\n",(0,i.jsxs)(t.p,{children:["We will learn to handle this mildly complex relationship with ",(0,i.jsx)(t.code,{children:"Caqti"})," and ",(0,i.jsx)(t.code,{children:"PostgreSQL"}),":"]}),"\n",(0,i.jsx)(t.mermaid,{value:'erDiagram\n    AUTHOR one to one or many BIBLIOGRAPHY : ""\n    AUTHOR {\n        int id PK\n        string first_name "NOT NULL"\n        string middle_name "NULL"\n        string last_name "NOT NULL"\n    }\n    BOOK one to one or many BIBLIOGRAPHY : ""\n    BOOK {\n        int id PK\n        string title "NOT NULL"\n        string description "NOT NULL"\n        string isbn "NOT NULL UNIQUE"\n        date published_on "NOT NULL"\n    }\n    BIBLIOGRAPHY {\n        int author_id FK\n        int book_id FK\n    }'}),"\n",(0,i.jsxs)(t.ul,{children:["\n",(0,i.jsx)(t.li,{children:"an author can publish one or many books"}),"\n",(0,i.jsx)(t.li,{children:"a book can be written by one or many authors"}),"\n"]})]})}function h(n={}){const{wrapper:t}={...(0,s.R)(),...n.components};return t?(0,i.jsx)(t,{...n,children:(0,i.jsx)(c,{...n})}):c(n)}}}]);