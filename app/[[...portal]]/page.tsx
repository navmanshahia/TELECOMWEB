import Experience from '../experience';
export default async function Page({params}:{params:Promise<{portal?:string[]}>}){const p=await params;return <Experience initial={p.portal?.[0]||'home'}/>}