@module("./logo.svg") external logo: string = "default"

%%raw(`import './App.css';`)

type useFormMethod<'a, 'b> = {
  register: 'a,
  handleSubmit: 'b,
}

@bs.module("react-hook-form") external useForm: ('input) => useFormMethod<'a, 'b> = "useForm" 

type loginForm = {
  id: string,
  password: string,
  repeatedPassword: string,
}

@react.component
let make = () => {
  let { register, handleSubmit } = useForm()

  let onSubmit = (data: loginForm) => {
    Js.log(data.id)
  }

  let onClick = handleSubmit(. onSubmit)

  <>
    <div>
      {React.string(`아이디`)}
      <input name="id" ref={ReactDOM.Ref.domRef(register)} />
    </div>
    <div>
      {React.string(`비밀번호`)}
      <input name="password" ref={ReactDOM.Ref.domRef(register)} />
    </div>
    <div>
      {React.string(`비밀번호 확인`)}
      <input name="repeatedPassword" ref={ReactDOM.Ref.domRef(register)} />
    </div>
    <div><button onClick>{React.string(`로그인`)}</button></div>
  </>
}
